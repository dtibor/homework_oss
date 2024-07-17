terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.esxi_server}/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


locals {
master_hosts = { for i in range(var.master_number) : "${var.prefix}-master${i+1}" => {role = "master", ip = "${var.base_ip}${var.ip_start + i}"} }
worker_hosts = { for i in range(var.worker_number) : "${var.prefix}-worker${i+1}" => {role = "worker", ip = "${var.base_ip}${var.ip_start + var.master_number + i}"} }
lb           = { "${var.prefix}-lb" = { role = "lb", ip = "${var.base_ip}${var.ip_start + var.master_number + var.worker_number}" } }
all_hosts = merge(local.master_hosts, local.worker_hosts, local.lb)
}


resource "vsphere_virtual_machine" "vm" {
  for_each = local.all_hosts

  name             = each.key
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  firmware         = var.firmware
  num_cpus         = var.num_cpu
  memory           = var.num_memory
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = each.key
        domain    = "your_domain"
      }

      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip
    }
  }
}


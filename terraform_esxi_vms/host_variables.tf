##########################################

variable "firmware" {
description = "firmware type of vms"
type        = string
}

variable "vm_template" {
description = "template for vm"
type        = string
}

variable "num_cpu" {
description = "core number of cpu in vm"
type        = number
}

variable "num_memory" {
description = "memory for vm"
type        = number
}

variable "prefix" {
  description = "prefix of hostnames"
  type        = string
}

variable "master_number" {
  description = "master node number"
  type        = number
}

variable "worker_number" {
  description = "worker node number"
  type        = number
}

variable "base_ip" {
  description = "first 3 octet for hosts"
  type        = string
}

variable "ip_start" {
  description = "The last octet for hosts, first host starts with this number"
  type        = number
}

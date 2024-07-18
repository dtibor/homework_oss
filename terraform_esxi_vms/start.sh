#!/bin/bash

inventory="inv.ini"


start_terraform() {
terraform init
read -s -p "Enter vSphere Password: " vsphere_password
TF_VAR_vsphere_password=$vsphere_password terraform apply --auto-approve
}

#start_ansible() {
#ansible-playbook ./ssh_auth/install_ssh.yml -i $inventory --ask-pass --ask-become-pass -e "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'"
#ansible-playbook ./install_vault/install_vault.yaml -i $inventory
#}


start_terraform
#sleep 5
#start_ansible

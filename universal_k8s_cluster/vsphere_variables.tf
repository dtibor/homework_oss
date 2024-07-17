#vsphere variables
variable "vsphere_password" {
description = "vSphere password"
type        = string
sensitive   = true
}

variable "vsphere_user" {
description = "vSphere user"
type        = string
}

variable "vsphere_server" {
description = "vSphere server address"
type        = string
}

variable "esxi_server" {
description = "vSphere server address"
type        = string
}

variable "gateway_ip" {
description = "gateway address"
type        = string
}

variable "proxmox_node_name" {}
variable "proxmox_host" { }
variable "proxmox_user" { }
variable "proxmox_password" {
  sensitive = true
}
variable "proxmox_ssh_user" { }
variable "proxmox_ssh_password" {
  sensitive = true
}

variable "template_name" { }

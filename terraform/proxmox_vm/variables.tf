variable "proxmox_node_prefix" { }
variable "proxmox_node_name" { }
variable "proxmox_host" { }
variable "proxmox_ssh_user" { }
variable "proxmox_ssh_password" {
  sensitive = true
}

variable "tailscale_tailnet_name" { }

variable "template_name" { }
variable "is_server" {
  default = "true"
}

variable "cpu" {
  default = 8
}
variable "memory" {
  default = 16384
}

variable "join_node" {}

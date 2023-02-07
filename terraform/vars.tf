variable "vm_count" {
  default = 1
}

variable "do_vm_count" {
  default = 1
}

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

variable "tailscale_api_key" {
  sensitive = true
}

variable "tailscale_tailnet" { }

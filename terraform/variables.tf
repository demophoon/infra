variable "proxmox_ssh_user" { }
variable "proxmox_ssh_password" {
  sensitive = true
}
variable "proxmox_template_name" { }

variable "tailscale_tailnet_name" { }

provider "proxmox" {
  pm_api_url = "https://${var.proxmox_host}:8006/api2/json"
  pm_user = var.proxmox_user
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

module "vm-beryllium" {
  count = 1
  source = "./proxmox_vm"

  proxmox_node_name = "proxmox"
  proxmox_host = "192.168.1.4"
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_ssh_user = var.proxmox_ssh_user
  proxmox_ssh_password = var.proxmox_ssh_password
  template_name = var.template_name
}

module "vm-nuc" {
  count = 1
  source = "./proxmox_vm"

  proxmox_node_name = "nuc"
  proxmox_host = "192.168.1.35"
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  proxmox_ssh_user = var.proxmox_ssh_user
  proxmox_ssh_password = var.proxmox_ssh_password
  template_name = var.template_name
}

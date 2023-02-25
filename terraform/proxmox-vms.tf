provider "proxmox" {
  pm_tls_insecure = true
}

module "vm-proxmox" {
  for_each = {
    proxmox = {
      name = "proxmox"
      host = "192.168.1.4"
      cpu = 8
      memory = 16384
    }
    proxmox-b = {
      name = "proxmox"
      host = "192.168.1.4"
      cpu = 6
      memory = 12288
    }
    nuc = {
      name = "nuc"
      host = "192.168.1.35"
      cpu = 4
      memory = 8192
    }
    nuc-b = {
      name = "nuc"
      host = "192.168.1.35"
      cpu = 4
      memory = 8192
    }
  }

  source = "./proxmox_vm"
  proxmox_node_name = each.value.name
  proxmox_host = each.value.host

  cpu = each.value.cpu
  memory = each.value.memory
  proxmox_ssh_user = var.proxmox_ssh_user
  proxmox_ssh_password = var.proxmox_ssh_password
  template_name = var.proxmox_template_name

  tailscale_tailnet_name = var.tailscale_tailnet_name
}

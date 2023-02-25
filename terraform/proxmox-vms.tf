module "vm-proxmox" {
  for_each = {
    beryllium = {
      name = "proxmox"
      host = "192.168.1.4"
      cpu = 12
      memory = 24576
      is_server = "true"
    }
    beryllium-2 = {
      name = "proxmox"
      host = "192.168.1.4"
      cpu = 10
      memory = 24576
      is_server = "true"
    }
    nuc = {
      name = "nuc"
      host = "192.168.1.35"
      cpu = 8
      memory = 16384
      is_server = "true"
    }
  }

  source = "./proxmox_vm"

  proxmox_node_prefix = each.key
  proxmox_node_name = each.value.name
  proxmox_host = each.value.host
  is_server = each.value.is_server

  cpu = each.value.cpu
  memory = each.value.memory
  proxmox_ssh_user = var.proxmox_ssh_user
  proxmox_ssh_password = var.proxmox_ssh_password
  template_name = var.proxmox_template_name

  tailscale_tailnet_name = var.tailscale_tailnet_name

  join_node = local.join_nodes[0]
}

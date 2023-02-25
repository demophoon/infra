data "tailscale_devices" "proxmox" {
  name_prefix = "beryllium-"
}

data "tailscale_devices" "nuc" {
  name_prefix = "nuc-"
}

data "tailscale_devices" "do" {
  name_prefix = "do-"
}

locals {
  join_nodes = flatten([
    [ for node in data.tailscale_devices.proxmox.devices : node.addresses[0] ],
    [ for node in data.tailscale_devices.nuc.devices : node.addresses[0] ],
    [ for node in data.tailscale_devices.do.devices : node.addresses[0] ],
  ])
}

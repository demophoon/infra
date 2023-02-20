resource "tailscale_tailnet_key" "ts_key" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
}

data "tailscale_device" "ts_device" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]
  name     = "${random_pet.server_name.id}.${var.tailscale_tailnet_name}"
  wait_for = "5m"
}

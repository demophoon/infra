provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailscale_tailnet
}

resource "tailscale_tailnet_key" "do_ts_key" {
  count = var.do_vm_count
  lifecycle {
    replace_triggered_by = [
      random_pet.do_server_name[count.index].id,
    ]
  }
  reusable      = true
  ephemeral     = true
  preauthorized = true
}

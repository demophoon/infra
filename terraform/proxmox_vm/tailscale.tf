resource "tailscale_tailnet_key" "ts_key" {
  lifecycle {
    replace_triggered_by = [
      random_pet.server_name,
    ]
  }
  depends_on = [random_pet.server_name]
  reusable      = false
  ephemeral     = true
  preauthorized = true
}

output "tailscale_key" {
  description = "Tailscale key"
  value = tailscale_tailnet_key.ts_key.key
  sensitive = true
}

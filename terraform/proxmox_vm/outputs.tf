output "ip" {
  description = "Public IP of Proxmox Instance"
  value = proxmox_vm_qemu.vm.default_ipv4_address
}

output "tailscale_ip" {
  description = "Tailscale IP of Proxmox Instance"
  value = data.tailscale_device.ts_device.addresses[0]
}

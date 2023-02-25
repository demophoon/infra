output "ip" {
  description = "Public IP of Proxmox Instance"
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses
}

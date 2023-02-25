output "do_ips" {
  description = "IPs of Digitalocean Droplets"
  value = [ for vm in module.vm-do : vm.ip ]
}

output "proxmox_ips" {
  description = "IPs of Proxmox VMs"
  value = flatten([
    [ for vm in module.vm-proxmox : vm.ip ]
  ])
}

output "tailscale_ips" {
  description = "Tailscale IPs"
  value = flatten([
    #[ for vm in module.vm-proxmox : vm.tailscale_ip ],
    #[ for vm in module.vm-do : vm.tailscale_ip ],
    #module.vm-oci.*.tailscale_ip,
  ])
}

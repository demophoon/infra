data "vault_kv_secret" "ssh_ca" {
  path = "proxmox/config/ca"
}

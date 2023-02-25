data "template_file" "nomad_config" {
  template = file("${path.module}/templates/nomad.hcl")
  vars = {
    region      = "cascadia"
    provider    = "virtual"
    vault_token = vault_token.nomad_token.client_token
  }
}

data "template_file" "docker_config" {
  template = file("${path.module}/templates/docker.json")
}

data "template_file" "consul_config" {
  template = file("${path.module}/templates/consul.hcl")
}

data "template_file" "vault_config" {
  template = file("${path.module}/templates/vault.hcl")
}

data "template_file" "keepalived_config" {
  template = file("${path.module}/templates/keepalived.conf")
  vars = {
    vrrp_priority = random_integer.vrrp_priority.result
  }
}

data "template_file" "sshd_config" {
  template = file("${path.module}/templates/sshd_config")
}

// Required tokens and certs
// TODO: Generate certificates for Nomad and Consul
resource "vault_token" "nomad_token" {
  policies = ["nomad-server"]
  ttl = "720h"
  no_parent = true
}

// Generate Vault Certificate
resource "vault_pki_secret_backend_cert" "vault_internal" {
  backend = "pki"
  name = "backplane"

  common_name = "vault.service.consul.demophoon.com"
  alt_names = [
    "active.vault.service.consul.demophoon.com",
    "standby.vault.service.consul.demophoon.com",
  ]
}

data "vault_kv_secret" "ssh_ca" {
  path = "proxmox/config/ca"
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.cfg")
  vars = {
    hostname          = random_pet.server_name.id
    ts_key            = tailscale_tailnet_key.ts_key.key
    ssh_ca            = base64encode(data.vault_kv_secret.ssh_ca.data.public_key)
    sshd_config       = base64encode(data.template_file.sshd_config.rendered)
    docker_config     = base64encode(data.template_file.docker_config.rendered)
    nomad_config      = base64encode(data.template_file.nomad_config.rendered)
    consul_config     = base64encode(data.template_file.consul_config.rendered)
    vault_config      = base64encode(data.template_file.vault_config.rendered)
    keepalived_config = base64encode(data.template_file.keepalived_config.rendered)
    vault_pki_cert    = base64encode(vault_pki_secret_backend_cert.vault_internal.certificate)
    vault_pki_key     = base64encode(vault_pki_secret_backend_cert.vault_internal.private_key)
  }
}

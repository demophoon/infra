data "template_file" "nomad_config" {
  template = file("${path.module}/templates/nomad.hcl")
  vars = {
    region      = "cascadia"
    provider    = "virtual"
    vault_token = vault_token.nomad_token.client_token
  }
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

// Required tokens and certs
// TODO: Generate certificates for Nomad and Consul
resource "vault_token" "nomad_token" {
  policies = ["nomad-server"]
  ttl = "720h"
  no_parent = true
}

resource "vault_pki_secret_backend_cert" "vault_internal" {
  backend = "pki"
  name = "backplane"

  common_name = "vault.service.consul.demophoon.com"
  alt_names = [
    "active.vault.service.consul.demophoon.com",
    "standby.vault.service.consul.demophoon.com",
  ]
}


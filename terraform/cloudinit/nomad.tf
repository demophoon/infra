resource "vault_token" "nomad_token" {
  policies = ["nomad-server"]
  ttl = "2160h"
  no_parent = true
}

resource "vault_pki_secret_backend_cert" "nomad_internal" {
  backend = "pki"
  name = "backplane"

  common_name = "nomad.service.consul.demophoon.com"
  alt_names = [
    "${var.hostname}.blue-bowfin.ts.net",
    #"nomad-backplane.internal.demophoon.com",
    "nomad.internal.demophoon.com",
  ]
}

data "template_file" "nomad_config" {
  template = file("${path.module}/templates/nomad.hcl")
  vars = {
    region      = var.nomad_region
    provider    = var.nomad_provider
    vault_token = vault_token.nomad_token.client_token
    is_server   = var.server
  }
}


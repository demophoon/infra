resource "vault_pki_secret_backend_cert" "vault_internal" {
  backend = "pki"
  name = "backplane"

  common_name = "vault.service.consul.demophoon.com"
  alt_names = [
    "${var.hostname}.blue-bowfin.ts.net",
    "active.vault.service.consul.demophoon.com",
    "standby.vault.service.consul.demophoon.com",
    "vault-backplane.internal.demophoon.com",
  ]
}

data "template_file" "vault_config" {
  template = file("${path.module}/templates/vault.hcl")
}

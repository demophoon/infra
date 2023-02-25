
resource "vault_pki_secret_backend_cert" "consul_internal" {
  backend = "pki"
  name = "backplane"

  common_name = "consul.service.consul.demophoon.com"
  alt_names = [
    "${var.hostname}.blue-bowfin.ts.net",
    #"consul-backplane.internal.demophoon.com",
    "consul.internal.demophoon.com",
  ]
}

data "template_file" "consul_config" {
  template = file("${path.module}/templates/consul.hcl")
  vars = {
    join_devices = jsonencode(["vault", "provenance"])
    is_server   = var.server
  }
}


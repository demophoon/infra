// DigitalOcean
data "template_file" "do_nomad_config" {
  count = var.do_vm_count
  template = file("${path.module}/files/nomad.hcl")
  vars = {
    region      = "digitalocean"
    provider    = "digitalocean"
    vault_token = vault_token.do_nomad_token[count.index].client_token
  }
}

data "template_file" "do_consul_config" {
  count = var.do_vm_count
  template = file("${path.module}/files/consul.hcl")
}

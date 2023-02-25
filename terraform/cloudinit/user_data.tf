data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.cfg")
  vars = {
    hostname          = var.hostname
    ts_key            = module.ts.tailscale_key
    ssh_ca            = base64encode(data.vault_kv_secret.ssh_ca.data.public_key)
    sshd_config       = base64encode(data.template_file.sshd_config.rendered)
    nomad_config      = base64encode(data.template_file.nomad_config.rendered)
    consul_config     = base64encode(data.template_file.consul_config.rendered)
    vault_config      = base64encode(data.template_file.vault_config.rendered)
    keepalived_config = base64encode(data.template_file.keepalived_config.rendered)
    vault_pki_cert    = base64encode(vault_pki_secret_backend_cert.vault_internal.certificate)
    vault_pki_key     = base64encode(vault_pki_secret_backend_cert.vault_internal.private_key)
    consul_pki_cert    = base64encode(vault_pki_secret_backend_cert.consul_internal.certificate)
    consul_pki_key     = base64encode(vault_pki_secret_backend_cert.consul_internal.private_key)
    nomad_pki_cert    = base64encode(vault_pki_secret_backend_cert.nomad_internal.certificate)
    nomad_pki_key     = base64encode(vault_pki_secret_backend_cert.nomad_internal.private_key)
  }
}

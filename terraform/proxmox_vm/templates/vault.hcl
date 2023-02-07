ui = true

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

service_registration "consul" {
  address = "127.0.0.1:8500"
  service = "vault"
}

listener "tcp" {
  address       = "{{ GetInterfaceIP \"tailscale0\" }}:8200"
  tls_cert_file = "/opt/vault/certs/cert.pem"
  tls_key_file  = "/opt/vault/certs/priv.key"
}

ui = true

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

service_registration "consul" {
  address = "127.0.0.1:8500"
  service = "vault"
}

api_addr = "https://{{ GetInterfaceIP \"tailscale0\" }}:8200"
cluster_addr = "https://{{ GetInterfaceIP \"tailscale0\" }}:8201"

listener "tcp" {
  address       = "{{ GetInterfaceIP \"tailscale0\" }}:8200"
  tls_cert_file = "/opt/vault/certs/cert.pem"
  tls_key_file  = "/opt/vault/certs/priv.key"
}

listener "tcp" {
  address       = "127.0.0.1:8200"
  tls_cert_file = "/opt/vault/certs/cert.pem"
  tls_key_file  = "/opt/vault/certs/priv.key"
}

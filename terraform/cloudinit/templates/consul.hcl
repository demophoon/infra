data_dir = "/opt/consul"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"docker0\" }} {{ GetInterfaceIP \"eth0\" }} {{ GetInterfaceIP \"tailscale0\" }}"
bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}"

retry_join = ${join_devices}
bootstrap_expect = 3

server = ${is_server}
enable_local_script_checks = true

ui_config {
  enabled = true
}

tls {
  https {
    cert_file = "/opt/consul/certs/cert.pem"
    key_file = "/opt/consul/certs/priv.key"
  }
}

addresses {
  dns = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }} {{ GetInterfaceIP \"tailscale0\" }}",
  http = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }} {{ GetInterfaceIP \"tailscale0\" }}",
  grpc = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }} {{ GetInterfaceIP \"tailscale0\" }}",
}

domain = "consul.demophoon.com."

connect {
  enabled = true
}

ports {
  https = 8501
  grpc = 8502
}

telemetry {
  prometheus_retention_time = "10m"
}

services {
  name = "nomad-ui"
  id = "nomad-ui"
  port = 4646
  tags = [
    "internal=true",
    "traefik.enable=true",
    "traefik.http.routers.nomad-backplane.rule=Host(`nomad-backplane.internal.demophoon.com`)",
  ]
}

services {
  name = "consul-ui"
  id = "consul-ui"
  port = 8500
  tags = [
    "internal=true",
    "traefik.enable=true",
    "traefik.http.routers.consul-backplane.rule=Host(`consul-backplane.internal.demophoon.com`)",
  ]
}

services {
  name = "vault-ui"
  id = "vault-ui"
  port = 8200
  tags = [
    "internal=true",
    "traefik.enable=true",
    "traefik.tcp.routers.vault-backplane.rule=HostSNI(`vault-backplane.internal.demophoon.com`)",
    "traefik.tcp.routers.vault-backplane.tls.passthrough=true",
  ]
  checks = [
    {
      id = "active"
      name = "active"
      args = ["/usr/bin/vault", "status", "-tls-server-name", "vault.service.consul.demophoon.com"]
      interval = "5s"
      timeout = "2s"
    }
  ]
}

# External Services
services {
  name = "tubeszb"
  id = "tubeszb"
  address = "192.168.1.114"
  tags = [
    "internal=true",
  ]
}

services {
  name = "truenas"
  id = "truenas"
  address = "192.168.1.34"
  port = 80
  tags = [
    "internal=true",
  ]
}

services {
  name = "plex"
  id = "plex"
  address = "192.168.1.34"
  port = 32400
  tags = [
    "traefik.enable=true",
    "traefik.http.routers.plex.rule=host(`plex.brittg.com`)"
  ]
}

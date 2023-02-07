data_dir = "/opt/consul"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"docker0\" }} {{ GetInterfaceIP \"ens18\" }} {{ GetInterfaceIP \"tailscale0\" }}"
bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}"

retry_join = [
  "100.82.113.104", # Strato
  "100.76.155.95",  # Mecca
  "100.94.10.66",   # Doyle
]

server = true

ui_config {
  enabled = true
}

addresses {
  dns = "127.0.0.1 {{ GetInterfaceIP \"ens18\" }} {{ GetInterfaceIP \"tailscale0\" }}",
  http = "127.0.0.1 {{ GetInterfaceIP \"ens18\" }} {{ GetInterfaceIP \"tailscale0\" }}",
  grpc = "127.0.0.1 {{ GetInterfaceIP \"ens18\" }} {{ GetInterfaceIP \"tailscale0\" }}",
}

domain = "consul.demophoon.com."

connect {
  enabled = true
}

ports {
  grpc = 8502
}

telemetry {
  prometheus_retention_time = "10m"
}

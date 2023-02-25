job "traefik" {
  datacenters = ["dc1", "cascadia"]
  priority = 100

  type = "system"

  group "web" {
    count = 1
    network {
      port "http"      { static = 80 }
      port "https"     { static = 443 }
      port "ssh"       { static = 2222 }
      port "dashboard" { static = 8080 }

      port "valheim"  { static = 2456 }
      port "valheim2" { static = 2457 }
      port "valheim3" { static = 2458 }

      port "synapse" { static = 8448 }
    }

    task "traefik" {
      driver = "docker"

      restart {
        delay = "30s"
        interval = "5m"
        mode = "delay"
      }

      config {
        image = "traefik:v3.0"
        args = [
          "--configFile", "/local/traefik.yaml"
        ]
        labels { group = "http" }
        network_mode = "host"
        ports = [
          "http",
          "https",
          "ssh",
          "dashboard",
          "valheim",
          "valheim2",
          "valheim3",
          "synapse",
        ]
      }
      resources {
        cpu = 256
        memory = 128
      }
      service {
        name = "traefik"
        port = "http"
      }
      service {
        name = "traefik-https"
        port = "https"
      }
      service {
        name = "traefik-ssh"
        port = "ssh"
      }
      service {
        name = "traefik-dashboard"
        port = "dashboard"
      }
      service {
        name = "traefik-valheim"
        port = "valheim"
      }
      service {
        name = "traefik-valheim2"
        port = "valheim2"
      }
      service {
        name = "traefik-valheim3"
        port = "valheim3"
      }

      service {
        name = "traefik-synapse"
        port = "synapse"
      }

      # Configuration
      template {
        data = <<-EOF
${traefik_yaml}
        EOF
        destination = "local/traefik.yaml"
        left_delimiter = "{{{"
        right_delimiter = "}}}"
      }

      template {
        data = <<-EOF
        tls:
          stores:
            default:
              defaultCertificate:
                certFile: "/secrets/certs/cert.pem"
                keyFile: "/secrets/certs/key.pem"
          certificates:
            - certFile: "/secrets/certs/cert.pem"
              keyFile: "/secrets/certs/key.pem"
              stores:
                - "default"
        EOF
        destination = "local/config/tls.yaml"
      }

      template {
        data = <<-EOF
          {{ with secret "kv/data/traefik/certs/brittg-com" }}
          {{ .Data.data.cert | base64Decode }}
          {{ end }}
        EOF
        destination = "secrets/certs/cert.pem"
        perms = "600"
      }
      template {
        data = <<-EOF
          {{ with secret "kv/data/traefik/certs/brittg-com" }}
          {{ .Data.data.key | base64Decode }}
          {{ end }}
        EOF
        destination = "secrets/certs/key.pem"
        perms = "600"
      }
    }
  }

  vault {
    policies = ["traefik"]
  }
}

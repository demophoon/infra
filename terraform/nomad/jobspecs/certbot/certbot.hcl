job "certbot" {
  datacenters = ["cascadia"]

  type = "batch"

  periodic {
    cron             = "0 0 0 1 * * *"
    prohibit_overlap = true
  }

  group "certbot" {
    count = 1

    restart {
      attempts = 0
    }

    ephemeral_disk {
      migrate = true
      sticky  = true
      size    = 250
    }

    task "certbot" {
      driver = "docker"

      config {
        image = "certbot/dns-google:latest"
        args = [
          "certonly",
          #"--dry-run", "--test-cert",
          "--config", "/local/config.ini",
          "--deploy-hook", "/local/deploy.sh",

          "--dns-google",
          "--dns-google-credentials", "/secrets/sa.json",
          "--dns-google-propagation-seconds", "120",

          "--domain", "brittg.com",
          "--domain", "*.brittg.com",
          "--domain", "demophoon.com",
          "--domain", "*.demophoon.com",
          "--domain", "*.services.demophoon.com",
          "--domain", "*.internal.demophoon.com",
          "--domain", "*.cascadia.demophoon.com",
          "--domain", "tamagotchi.rodeo",
          "--domain", "*.tamagotchi.rodeo",
          "--domain", "brittslittlesliceofheaven.org",
          "--domain", "*.brittslittlesliceofheaven.org",
        ]
      }
      resources {
        cpu = 256
        memory = 128
      }

      template {
        data = <<EOF
email = letsencrypt@brittg.com
agree-tos = true
EOF
        destination = "local/config.ini"
      }

      template {
        data = <<EOF
#!/bin/sh
cat /etc/letsencrypt/live/brittg.com/privkey.pem | base64 -w 0 > /alloc/data/privkey.pem.b64
cat /etc/letsencrypt/live/brittg.com/fullchain.pem | base64 -w 0 > /alloc/data/fullchain.pem.b64
EOF
        destination = "local/deploy.sh"
        perms = "755"
      }

      template {
        data = <<EOF
{{ with secret "gcp/roleset/dns-admin/key" }}
{{ .Data.private_key_data | base64Decode }}
{{ end }}
EOF
        destination = "secrets/sa.json"
        perms = "600"
      }
    }

    task "post-process" {
      driver = "docker"

      lifecycle {
        hook = "poststop"
      }

      env {
        VAULT_ADDR = "https://active.vault.service.consul.demophoon.com:8200"
        VAULT_SKIP_VERIFY = "true"
      }

      config {
        image = "hashicorp/vault:latest"
        args = [
          "kv", "put",
          "-mount", "kv",
          "traefik/certs/brittg-com",
          "key=@/alloc/data/privkey.pem.b64",
          "cert=@/alloc/data/fullchain.pem.b64",
        ]
      }
      resources {
        cpu = 256
        memory = 128
      }
    }
  }

  vault {
    policies = ["certbot"]
  }
}

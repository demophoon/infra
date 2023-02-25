data "local_file" "traefik_yaml" {
  filename = "${path.module}/jobspecs/traefik/config/traefik.yaml"
}

resource "nomad_job" "datadog-agent" {
  jobspec = templatefile("${path.module}/jobspecs/datadog/datadog.hcl", {
    datadog_api_key = var.datadog_api_key
    datadog_site = var.datadog_site
  })
  hcl2 { enabled = true }
}

resource "nomad_job" "traefik" {
  jobspec = templatefile("${path.module}/jobspecs/traefik/traefik.hcl", {
    traefik_yaml = data.local_file.traefik_yaml.content
  })
  hcl2 { enabled = true }
}

resource "nomad_job" "certbot" {
  jobspec = file("${path.module}/jobspecs/certbot/certbot.hcl")
  hcl2 { enabled = true }
}

# Home Assistant
resource "nomad_job" "homeassistant" {
  jobspec = file("${path.module}/jobspecs/homeassistant/homeassistant.hcl")
  hcl2 { enabled = true }
}

resource "nomad_job" "registry-cache" {
  jobspec = file("${path.module}/jobspecs/registry-cache/cache.hcl")
  hcl2 { enabled = true }
}

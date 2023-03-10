data "local_file" "traefik_yaml" {
  filename = "${path.module}/jobspecs/traefik/config/traefik.yaml"
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

resource "nomad_job" "homeassistant" {
  jobspec = file("${path.module}/jobspecs/homeassistant/homeassistant.hcl")
  hcl2 { enabled = true }
}

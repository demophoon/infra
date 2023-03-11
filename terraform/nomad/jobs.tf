data "local_file" "traefik_yaml" {
  filename = "${path.module}/jobspecs/traefik/config/traefik.yaml"
}

resource "nomad_job" "traefik" {
  jobspec = templatefile("${path.module}/jobspecs/traefik/traefik.hcl", {
    traefik_yaml = data.local_file.traefik_yaml.content
  })
  hcl2 {
    enabled = true
  }
}

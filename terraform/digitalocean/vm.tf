resource "random_pet" "server_name" {
  length = 1
  prefix = "do"
}

module "ci-data" {
  source = "../cloudinit"

  hostname = random_pet.server_name.id
  nomad_region = "digitalocean"
  nomad_provider = "virtual"
  server = true
}


resource "digitalocean_droplet" "web" {
  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }

  name      = random_pet.server_name.id
  image     = "ubuntu-22-04-x64"
  region    = "sfo3"
  size      = var.size
  #size      = "s-2vcpu-4gb-amd"
  #size      = "s-1vcpu-1gb-amd"
  #size      = "s-1vcpu-1gb-intel"
  user_data = module.ci-data.config
}

output "id" {
  description = "ID of droplet"
  value = digitalocean_droplet.web.id
}

output "ip" {
  description = "IP of droplet"
  value = digitalocean_droplet.web.ipv4_address
}

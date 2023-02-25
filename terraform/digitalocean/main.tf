terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.46.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.25.2"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.13.5"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.13.0"
    }
  }
}

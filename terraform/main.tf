terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.31.0"
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
    vault = {
      source = "hashicorp/vault"
      version = "3.13.0"
    }
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.25.2"
    }
    #vultr = {
    #  source = "vultr/vultr"
    #  version = "2.13.0"
    #}
    google = {
      source = "hashicorp/google"
      version = "4.46.0"
    }
    #oci = {
    #  source = "oracle/oci"
    #  version = "4.105.0"
    #}
    #unifi = {
    #  source = "paultyng/unifi"
    #  version = "0.39.0"
    #}
  }

  cloud {
    organization = "demophoon"

    workspaces {
      name = "prod-home"
    }
  }
}

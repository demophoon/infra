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
  }
}

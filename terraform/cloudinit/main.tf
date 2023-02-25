terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.13.5"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.13.0"
    }
  }
}

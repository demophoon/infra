terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.11"
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
      version = "3.11.0"
    }
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
  }

  backend "consul" {
    address = "consul.service.consul.demophoon.com:8500"
    scheme  = "http"
    path    = "terraform/concert"
  }
}

provider "vault" {
  address = "https://active.vault.service.consul.demophoon.com:8200"
  tls_server_name = "active.vault.service.consul.demophoon.com"
  skip_tls_verify = true
  token = "hvs.CAESIJcVz5DNIa5LduqoaxPOJGzrcVM2GQzz8AerAGbFe4dbGh4KHGh2cy5JZkVRS2x2ekVaRnNpR0FNZUNzS1J0dFU"
}


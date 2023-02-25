terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

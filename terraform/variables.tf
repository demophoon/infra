variable "proxmox_ssh_user" { }
variable "proxmox_ssh_password" {
  sensitive = true
}
variable "proxmox_template_name" { }

variable "tailscale_tailnet_name" { }

variable "tenancy_ocid" { }
variable "availability_domain" { }
variable "shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "datadog_api_key" { }
variable "datadog_site" { }

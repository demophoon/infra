resource "random_pet" "server_name" {
  length = 1
  prefix = var.proxmox_node_prefix
}

module "ci-data" {
  source = "../cloudinit"

  hostname = random_pet.server_name.id
  nomad_region = "cascadia"
  nomad_provider = "virtual"
  server = var.is_server
}


resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "nuc"

  source_raw {
    data = module.ci-data.config
    file_name = "${random_pet.server_name.id}.cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = random_pet.server_name.id
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]
  node_name = "nuc"

  agent {
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  clone {
    datastore_id = "local-lvm"
    vm_id = var.template_name
  }

  cpu {
    cores = var.cpu
    type = "host"
  }

  memory {
    dedicated = var.memory
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
}

resource "random_pet" "server_name" {
  length = 1
  prefix = var.proxmox_node_name
  keepers = {
    nomad = sha256(data.template_file.nomad_config.rendered),
    consul = sha256(data.template_file.consul_config.rendered),
    vault = sha256(data.template_file.vault_config.rendered),
  }
}

resource "random_integer" "vrrp_priority" {
  min = 100
  max = 500
  keepers = {
    vm = random_pet.server_name.id
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.cfg")
  vars = {
    hostname          = random_pet.server_name.id
    ts_key            = tailscale_tailnet_key.ts_key.key
    ssh_ca            = base64encode(data.vault_kv_secret.ssh_ca.data.public_key)
    sshd_config       = base64encode(data.template_file.sshd_config.rendered)
    docker_config     = base64encode(data.template_file.docker_config.rendered)
    nomad_config      = base64encode(data.template_file.nomad_config.rendered)
    consul_config     = base64encode(data.template_file.consul_config.rendered)
    vault_config      = base64encode(data.template_file.vault_config.rendered)
    keepalived_config = base64encode(data.template_file.keepalived_config.rendered)
    vault_pki_cert    = base64encode(vault_pki_secret_backend_cert.vault_internal.certificate)
    vault_pki_key     = base64encode(vault_pki_secret_backend_cert.vault_internal.private_key)
  }
}

data "vault_kv_secret" "ssh_ca" {
  path = "proxmox/config/ca"
}

resource "local_file" "cloud_init_user_data_file" {
  content = data.template_file.user_data.rendered
  filename = "${path.module}/rendered/${random_pet.server_name.id}-user_data.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  connection {
    type     = "ssh"
    user     = "${var.proxmox_ssh_user}"
    password = "${var.proxmox_ssh_password}"
    host     = "${var.proxmox_host}"
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file.filename
    destination = "/var/lib/vz/snippets/user_data_vm-${random_pet.server_name.id}.yml"
  }
}

// Primary VM resource
resource "proxmox_vm_qemu" "vm" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]
  lifecycle {
    ignore_changes = [
      disk,
      desc,
      clone,
    ]
  }

  name = "${random_pet.server_name.id}"
  target_node = var.proxmox_node_name
  clone = var.template_name
  pool = ""

  agent = 1

  cores = var.cpu
  sockets = 1
  memory = var.memory

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    type = "scsi"
    storage = "local-lvm"
    size = "100G"
  }

  cicustom                = "user=local:snippets/user_data_vm-${random_pet.server_name.id}.yml"
  cloudinit_cdrom_storage = "local-lvm"
}

packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

source "proxmox-iso" "nuc" {
  proxmox_url              = "https://192.168.1.35:8006/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  node                     = "nuc"
  task_timeout             = "10m"

  iso_url          = "https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"
  iso_storage_pool = "local"
  iso_checksum     = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  additional_iso_files {
    cd_files         = ["./cd/*"]
    cd_label         = "cidata"
    unmount          = true
    iso_storage_pool = "local"
  }

  memory = 3072
  cores = 4
  os     = "l26"
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  disks {
    type              = "scsi"
    disk_size         = "64G"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm"
  }

  qemu_agent   = true
  ssh_username = "ubuntu"
  ssh_private_key_file = "~/.ssh/id_ed25519"
  ssh_timeout = "25m"

  boot_wait = "15s"
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "c<wait>",
    "set gfxpayload=keep",
    "<enter><wait>",
    "linux /casper/vmlinuz quiet<wait>",
    " autoinstall<wait>",
    " ds=nocloud;<wait>",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter><wait>",
  ]

  unmount_iso             = true
  template_name           = join("-", [
    "ubuntu",
    "2204",
    "base",
    formatdate("YYYYMMDD-hhmm", timestamp()),
  ])
}

source "proxmox-iso" "beryllium" {
  proxmox_url              = "https://192.168.1.4:8006/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  node                     = "proxmox"
  task_timeout             = "10m"

  iso_url          = "https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"
  iso_storage_pool = "local"
  iso_checksum     = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  additional_iso_files {
    cd_files         = ["./cd/*"]
    cd_label         = "cidata"
    unmount          = true
    iso_storage_pool = "local"
  }

  memory = 3072
  cores = 4
  os     = "l26"
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  disks {
    type              = "scsi"
    disk_size         = "64G"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm"
  }

  qemu_agent   = true
  ssh_username = "ubuntu"
  ssh_private_key_file = "~/.ssh/id_ed25519"
  ssh_timeout = "25m"

  boot_wait = "15s"
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "c<wait>",
    "set gfxpayload=keep",
    "<enter><wait>",
    "linux /casper/vmlinuz quiet<wait>",
    " autoinstall<wait>",
    " ds=nocloud;<wait>",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter><wait>",
  ]

  unmount_iso             = true
  template_name           = join("-", [
    "ubuntu",
    "2204",
    "base",
    formatdate("YYYYMMDD-hhmm", timestamp()),
  ])
}

build {
  name = "ubuntu-x86_64"
  sources = [
    "source.proxmox-iso.nuc",
    "source.proxmox-iso.beryllium",
  ]

  # Clean up the machine for cloud-init
  provisioner "shell" {
    execute_command = "echo 'ubuntu' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  provisioner "file" {
    source = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    execute_command = "echo 'ubuntu' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    inline = [
      "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg",
    ]
  }
}

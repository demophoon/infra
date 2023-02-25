data "template_file" "sshd_config" {
  template = file("${path.module}/templates/sshd_config")
}

resource "random_integer" "vrrp_priority" {
  min = 100
  max = 500
  keepers = {
    vm = var.hostname
  }
}

data "template_file" "keepalived_config" {
  template = file("${path.module}/templates/keepalived.conf")
  vars = {
    vrrp_priority = random_integer.vrrp_priority.result
  }
}

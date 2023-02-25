output "config" {
  description = "Cloud init config"
  value = data.template_file.user_data.rendered
}

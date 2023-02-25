module "nomad-jobs" {
  source = "./nomad"

  datadog_api_key = var.datadog_api_key
  datadog_site = var.datadog_site
}

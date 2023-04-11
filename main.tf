module "app_service" {
  source = "./modules/app-service"

  hostname = var.hostname
  backend_address = var.backend_address
  backend_ca_cert = var.backend_ca_cert
  shield_region = "hel-helsinki-fi"

  datadog_token = var.datadog_token
}

module "files_service" {
  source = "./modules/files-service"

  hostname = "files.${var.hostname}"
  app_hostname = var.hostname
  backend_address = var.files_backend_address
  shield_region = var.files_shield_region
}

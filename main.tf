module "app_service" {
  source = "./modules/app-service"

  hostname = var.hostname
  backend_name = var.backend_name
  backend_address = var.backend_address
  backend_ca_cert = var.backend_ca_cert
  shield_region = var.shield_region

  datadog_token = var.datadog_token

  signal_science_host = var.signal_science_host
  signal_science_shared_key = var.signal_science_shared_key

  ip_blocklist = var.ip_blocklist
  ip_blocklist_acl_name = var.ip_blocklist_acl_name
  as_blocklist = var.as_blocklist
  as_blocklist_name = var.as_blocklist_name
  as_request_blocklist = var.as_request_blocklist
  as_request_blocklist_name = var.as_request_blocklist_name
}

module "files_service" {
  source = "./modules/files-service"

  hostname = "files.${var.hostname}"
  backend_name = var.files_backend_name
  app_hostname = var.hostname
  backend_address = var.files_backend_address
  shield_region = var.files_shield_region
}

output "id" {
  description = "The ID of this resource"
  value       = fastly_service_vcl.app_service.id
}

output "active_version" {
  description = "The currently active version of the Fastly Service"
  value       = fastly_service_vcl.app_service.active_version
}

output "cloned_version" {
  description = "The latest cloned version by the provider"
  value       = fastly_service_vcl.app_service.cloned_version
}

output "ip_blocklist_acl_id" {
  description = "ID of the IP blocklist ACL"
  value       = var.ip_blocklist ? fastly_service_acl_entries.ip_blocklist_entries["IP Block list"].acl_id : null
}

output "as_blocklist_dictionary_id" {
  description = "ID of the AS blocklist dictionary"
  value       = var.as_blocklist ? fastly_service_dictionary_items.as_blocklist_entries["AS Blocklist"].dictionary_id : null
}

output "as_request_blocklist_dictionary_id" {
  description = "ID of the AS request blocklist dictionary"
  value       = var.as_blocklist ? fastly_service_dictionary_items.as_request_blocklist_entries["AS Requests Blocklist"].dictionary_id : null
}

output "ja3_blocklist_dictionary_id" {
  description = "ID of the JA3 blocklist dictionary"
  value       = var.ja3_blocklist ? fastly_service_dictionary_items.ja_blocklist_entries["JA3 Blocklist"].dictionary_id : null
}

output "tls_certificate_id" {
  description = "ID of the certificate issued by Fastly"
  value       = var.tls_enable ? fastly_tls_subscription.tls[0].certificate_id : null
}

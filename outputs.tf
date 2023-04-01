output "service_id" {
  description = "ID of the service in Fastly."
  value       = fastly_service_vcl.service.id
}

output "active_version" {
  description = "The currently active version of the Fastly Service."
  value       = fastly_service_vcl.service.active_version
}

output "cloned_version" {
  description = "The latest cloned version by the provider."
  value       = fastly_service_vcl.service.cloned_version
}

output "ip_blocklist_acl_id" {
  description = "The ID of the IP Blocklist ACL."
  value = {
    for k, v in fastly_service_acl_entries.ip_blocklist_entries : k => v.acl_id
  }
}

output "ip_blocklist_acl_entry_id" {
  description = "The ID of the IP Blocklist ACL enties."
  value = {
    for k, v in fastly_service_acl_entries.ip_blocklist_entries : k => v.id
  }
}

output "as_blocklist_dictionary_id" {
  description = "The ID of the AS Blocklist dictionary."
  value = {
    for k, v in fastly_service_dictionary_items.as_blocklist_entries : k => v.dictionary_id
  }
}

output "as_blocklist_dictionary_entry_id" {
  description = "The ID of the AS Blocklist dictionary entries."
  value = {
    for k, v in fastly_service_dictionary_items.as_blocklist_entries : k => v.id
  }
}

output "as_request_blocklist_dictionary_id" {
  description = "The ID of the AS Request Blocklist dictionary."
  value = {
    for k, v in fastly_service_dictionary_items.as_request_blocklist_entries : k => v.dictionary_id
  }
}

output "as_request_blocklist_dictionary_entry_id" {
  description = "The ID of the AS Blocklist dictionary entries."
  value = {
    for k, v in fastly_service_dictionary_items.as_blocklist_entries : k => v.id
  }
}

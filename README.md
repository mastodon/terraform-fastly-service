# Mastodon Terraform - Fastly Service for Mastodon Applications

Terraform module for creating all necessary services in Fastly for hosting an official Mastodon application (such as mastodon.social).

Contains much of the logic and default configuration that exists across all official Mastodon instances, while allowing customization where possible.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_fastly"></a> [fastly](#requirement\_fastly) | >= 4.1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_service"></a> [app\_service](#module\_app\_service) | ./modules/app-service | n/a |
| <a name="module_files_service"></a> [files\_service](#module\_files\_service) | ./modules/files-service | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_as_blocklist"></a> [as\_blocklist](#input\_as\_blocklist) | List of Autonomous Systems (AS) to block. | `list(number)` | `[]` | no |
| <a name="input_as_blocklist_name"></a> [as\_blocklist\_name](#input\_as\_blocklist\_name) | Name of the AS blocklist | `string` | `"Blocked AS Numbers"` | no |
| <a name="input_as_request_blocklist"></a> [as\_request\_blocklist](#input\_as\_request\_blocklist) | List of Autonomous Systems (AS) to block from making /api or /explore requests. | `list(number)` | `[]` | no |
| <a name="input_as_request_blocklist_name"></a> [as\_request\_blocklist\_name](#input\_as\_request\_blocklist\_name) | Name of the AS request blocklist | `string` | `"Blocked AS Numbers client requests"` | no |
| <a name="input_backend_address"></a> [backend\_address](#input\_backend\_address) | Address to use for connecting to the backend. Can be a hostname or an IP address. | `string` | n/a | yes |
| <a name="input_backend_ca_cert"></a> [backend\_ca\_cert](#input\_backend\_ca\_cert) | CA cert to use when connecting to the backend. | `string` | n/a | yes |
| <a name="input_backend_name"></a> [backend\_name](#input\_backend\_name) | Optional name for the backend. | `string` | `""` | no |
| <a name="input_datadog_token"></a> [datadog\_token](#input\_datadog\_token) | API key from Datadog. | `string` | n/a | yes |
| <a name="input_files_backend_address"></a> [files\_backend\_address](#input\_files\_backend\_address) | Address to use for connecting to the files backend. Can be a hostname or an IP address. | `string` | n/a | yes |
| <a name="input_files_backend_name"></a> [files\_backend\_name](#input\_files\_backend\_name) | Optional name for the files backend. | `string` | `""` | no |
| <a name="input_files_shield_region"></a> [files\_shield\_region](#input\_files\_shield\_region) | Which Fastly shield region to use for the files service. Should correspond with the shield code. | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname the service points to. | `string` | n/a | yes |
| <a name="input_ip_blocklist"></a> [ip\_blocklist](#input\_ip\_blocklist) | List of IP CIDR blocks to deny access. | `list(string)` | `[]` | no |
| <a name="input_ip_blocklist_acl_name"></a> [ip\_blocklist\_acl\_name](#input\_ip\_blocklist\_acl\_name) | Name for the ACL responsible for holding all the blocked IP ranges. | `string` | `"IP Block list"` | no |
| <a name="input_shield_region"></a> [shield\_region](#input\_shield\_region) | Which Fastly shield region to use. Should correspond with the shield code. | `string` | n/a | yes |
| <a name="input_signal_science_host"></a> [signal\_science\_host](#input\_signal\_science\_host) | Hostname to use to integrate with Signal Sciences | `string` | n/a | yes |
| <a name="input_signal_science_shared_key"></a> [signal\_science\_shared\_key](#input\_signal\_science\_shared\_key) | Shared key to use when integrating with Signal Sciences | `string` | n/a | yes |

## Outputs

No outputs.

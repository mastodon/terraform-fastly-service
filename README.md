Terraform module for creating a service in Fastly aligned with Mastodon's common practices and needs.

## Summary

This module attempts to simplify many aspects of creating a service in Fastly through terraform, while making it easier to implement many Mastodon-specific needs and practices.

Below is a quick list of notable features of this module:

- <h3>Mastodon infrastructure assumptions</h3>
  To avoid making the IaC too wordy or explicit, this module makes assumptions based on Mastodon's best practices for infrastructure deployment.
- <h3>Replicated GUI functionality</h3>
  There are certain features in the web frontend of Fastly (such as "Force TLS/HSTS") that provide easy access to certain feature sets by creating the dependent objects for you. This module attempts to replicate some of those pieces features through the use of simple flags.
- <h3>IP & AS blocklists</h3>
  Sometimes it's necessary to quickly block IP ranges or entire Autonomous Systems (AS) during attacks. To make this process easier, this module allows the user to simply specify IP CIDRs or AS numbers, and the necessary objects are created dynamically.
- <h3>Easier conditionals</h3>
  Fastly allows you to create "conditions" for when something will trigger. Because these are separate objects in the API, the terraform module requires you to create them separately. This module simplifies this by specifying conditions alongside some of the resources, ensuring that they are always tied together correctly.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_fastly"></a> [fastly](#requirement\_fastly) | >= 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fastly"></a> [fastly](#provider\_fastly) | >= 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fastly_service_acl_entries.ip_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_acl_entries) | resource |
| [fastly_service_dictionary_items.as_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_dictionary_items.as_request_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_vcl.service](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_vcl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate"></a> [activate](#input\_activate) | Conditionally prevents the Service from being activated. The apply step will continue to create a new draft version but will not activate it if this is set to false. | `bool` | `true` | no |
| <a name="input_as_blocklist"></a> [as\_blocklist](#input\_as\_blocklist) | List of Autonomous Systems (AS) to block. | `list(number)` | `[]` | no |
| <a name="input_as_blocklist_name"></a> [as\_blocklist\_name](#input\_as\_blocklist\_name) | Name of the AS blocklist | `string` | `"Blocked AS Numbers"` | no |
| <a name="input_as_request_blocklist"></a> [as\_request\_blocklist](#input\_as\_request\_blocklist) | List of Autonomous Systems (AS) to block from making explicit requests. | `list(number)` | `[]` | no |
| <a name="input_as_request_blocklist_name"></a> [as\_request\_blocklist\_name](#input\_as\_request\_blocklist\_name) | Name of the AS blocklist | `string` | `"Blocked AS Numbers client requests"` | no |
| <a name="input_backend_ssl_ca_cert"></a> [backend\_ssl\_ca\_cert](#input\_backend\_ssl\_ca\_cert) | CA certificate attached to origin. Used to pull value from Terraform Cloud. | `string` | `""` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | All backends that will be used for this service. | <pre>list(object({<br>    name    = string<br>    address = string<br><br>    auto_loadbalance  = optional(bool, true)<br>    healthcheck       = optional(string, "")<br>    max_conn          = optional(number, 200)<br>    max_tls_version   = optional(string, "")<br>    min_tls_version   = optional(string, "1.2")<br>    port              = optional(number, 443)<br>    shield            = optional(string, "")<br>    ssl_ca_cert       = optional(string, "")<br>    ssl_cert_hostname = optional(string, "")<br>    ssl_sni_hostname  = optional(string, "")<br>    override_host     = optional(string, "")<br>    use_ssl           = optional(bool, true)<br>  }))</pre> | `[]` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | The default Time-to-live (TTL) for requests. | `number` | `3600` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | A set of Domain names to serve as entry points for your Service. | <pre>list(object({<br>    name    = string<br>    comment = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_force_tls_enable_hsts"></a> [force\_tls\_enable\_hsts](#input\_force\_tls\_enable\_hsts) | Force TLS and HTTP Strict Transport Security (HSTS). Creates necessary objects in a similar fashion to the GUI flag. | `bool` | `true` | no |
| <a name="input_headers"></a> [headers](#input\_headers) | Headers to attach to HTTP responses. Automatically generates condition objects. | <pre>list(object({<br>    name        = string<br>    action      = string<br>    destination = string<br>    type        = string<br><br>    cache_condition             = optional(string, "")<br>    ignore_if_set               = optional(bool, false)<br>    priority                    = optional(number, 100)<br>    regex                       = optional(string, "")<br>    request_condition           = optional(string, "")<br>    request_condition_type      = optional(string, "REQUEST")<br>    request_condition_priority  = optional(number, 10)<br>    response_condition          = optional(string, "")<br>    response_condition_type     = optional(string, "REQUEST")<br>    response_condition_priority = optional(number, 10)<br>    source                      = optional(string, "")<br>    substitution                = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_healthchecks"></a> [healthchecks](#input\_healthchecks) | Endpoints to periodically test for backend health. | <pre>list(object({<br>    name = string<br>    host = string<br>    path = string<br><br>    check_interval    = optional(number, 60000)<br>    expected_response = optional(number, 200)<br>    headers           = optional(list(string), [])<br>    http_version      = optional(string, "1.1")<br>    initial           = optional(number, 1)<br>    method            = optional(string, "GET")<br>    threshold         = optional(number, 1)<br>    timeout           = optional(number, 5000)<br>    window            = optional(number, 2)<br>  }))</pre> | `[]` | no |
| <a name="input_hsts_duration"></a> [hsts\_duration](#input\_hsts\_duration) | How long the client should remember that the domain uses HSTS | `number` | `31557600` | no |
| <a name="input_http3"></a> [http3](#input\_http3) | Enables support for the HTTP/3 (QUIC) protocol. | `bool` | `true` | no |
| <a name="input_ip_blocklist"></a> [ip\_blocklist](#input\_ip\_blocklist) | List of IP CIDR blocks to deny access. | `list(string)` | `[]` | no |
| <a name="input_ip_blocklist_acl_name"></a> [ip\_blocklist\_acl\_name](#input\_ip\_blocklist\_acl\_name) | Name for the ACL responsible for holding all the blocked IP ranges. | `string` | `"IP Block list"` | no |
| <a name="input_logging_datadog"></a> [logging\_datadog](#input\_logging\_datadog) | Datalog connection and logging information. | <pre>object({<br>    name = string<br><br>    token  = optional(string, "")<br>    format = optional(string, "")<br>    region = optional(string, "EU")<br>  })</pre> | `null` | no |
| <a name="input_logging_datadog_token"></a> [logging\_datadog\_token](#input\_logging\_datadog\_token) | API key from Datadog. Used to pull value from Terraform Cloud. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Fastly service itself | `string` | n/a | yes |
| <a name="input_products"></a> [products](#input\_products) | List of additional Fastly products to enable on the service. | <pre>object({<br>    brotli_compression = optional(bool, false)<br>    domain_inspector   = optional(bool, false)<br>    image_optimizer    = optional(bool, false)<br>    origin_inspector   = optional(bool, false)<br>    websockets         = optional(bool, false)<br>  })</pre> | <pre>{<br>  "brotli_compression": false,<br>  "domain_inspector": false,<br>  "image_optimizer": false,<br>  "origin_inspector": false,<br>  "websockets": false<br>}</pre> | no |
| <a name="input_responses"></a> [responses](#input\_responses) | Custom response objects. Automatically generates condition objects. | <pre>list(object({<br>    name               = string<br>    content            = string<br>    content_type       = string<br>    condition          = string<br>    condition_type     = string<br>    condition_priority = optional(number, 10)<br>    response           = string<br>    status             = string<br>  }))</pre> | `[]` | no |
| <a name="input_snippets"></a> [snippets](#input\_snippets) | Custom VCL snippets to insert. | <pre>list(object({<br>    name     = string<br>    content  = string<br>    type     = string<br>    priority = optional(number, 100)<br>  }))</pre> | `[]` | no |
| <a name="input_stale_if_error"></a> [stale\_if\_error](#input\_stale\_if\_error) | Enables serving a stale object if there is an error. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_version"></a> [active\_version](#output\_active\_version) | The currently active version of the Fastly Service. |
| <a name="output_as_blocklist_dictionary_entry_id"></a> [as\_blocklist\_dictionary\_entry\_id](#output\_as\_blocklist\_dictionary\_entry\_id) | The ID of the AS Blocklist dictionary entries. |
| <a name="output_as_blocklist_dictionary_id"></a> [as\_blocklist\_dictionary\_id](#output\_as\_blocklist\_dictionary\_id) | The ID of the AS Blocklist dictionary. |
| <a name="output_as_request_blocklist_dictionary_entry_id"></a> [as\_request\_blocklist\_dictionary\_entry\_id](#output\_as\_request\_blocklist\_dictionary\_entry\_id) | The ID of the AS Blocklist dictionary entries. |
| <a name="output_as_request_blocklist_dictionary_id"></a> [as\_request\_blocklist\_dictionary\_id](#output\_as\_request\_blocklist\_dictionary\_id) | The ID of the AS Request Blocklist dictionary. |
| <a name="output_cloned_version"></a> [cloned\_version](#output\_cloned\_version) | The latest cloned version by the provider. |
| <a name="output_ip_blocklist_acl_entry_id"></a> [ip\_blocklist\_acl\_entry\_id](#output\_ip\_blocklist\_acl\_entry\_id) | The ID of the IP Blocklist ACL enties. |
| <a name="output_ip_blocklist_acl_id"></a> [ip\_blocklist\_acl\_id](#output\_ip\_blocklist\_acl\_id) | The ID of the IP Blocklist ACL. |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ID of the service in Fastly. |

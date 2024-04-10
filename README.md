# Mastodon Terraform - Fastly Service for Mastodon Applications

Terraform module for creating all necessary services in Fastly for hosting an official Mastodon application (such as mastodon.social).

Contains much of the logic and default configuration that exists across all official Mastodon instances, while allowing customization where possible.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_fastly"></a> [fastly](#requirement\_fastly) | >= 5.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fastly"></a> [fastly](#provider\_fastly) | >= 5.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fastly_service_acl_entries.ip_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_acl_entries) | resource |
| [fastly_service_dictionary_items.as_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_dictionary_items.as_request_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_dictionary_items.edge_security](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_dictionary_items.ja_blocklist_entries](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items) | resource |
| [fastly_service_vcl.app_service](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_vcl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_as_blocklist"></a> [as\_blocklist](#input\_as\_blocklist) | Whether to enable the AS blocklist ACLs. Must be managed externally, unless as\_blocklist\_items is given. | `bool` | `true` | no |
| <a name="input_as_blocklist_items"></a> [as\_blocklist\_items](#input\_as\_blocklist\_items) | List of Autonomous Systems (AS) to block. This will make the Dictionary object 'managed' by terraform. | `list(number)` | `[]` | no |
| <a name="input_as_blocklist_name"></a> [as\_blocklist\_name](#input\_as\_blocklist\_name) | Name of the AS blocklist | `string` | `"AS Blocklist"` | no |
| <a name="input_as_request_blocklist_items"></a> [as\_request\_blocklist\_items](#input\_as\_request\_blocklist\_items) | List of Autonomous Systems (AS) to block from making /api or /explore requests. This will make the Dictionary object 'managed' by terraform. | `list(number)` | `[]` | no |
| <a name="input_as_request_blocklist_name"></a> [as\_request\_blocklist\_name](#input\_as\_request\_blocklist\_name) | Name of the AS request blocklist | `string` | `"AS Requests Blocklist"` | no |
| <a name="input_backend_address"></a> [backend\_address](#input\_backend\_address) | Address to use for connecting to the backend. Can be a hostname or an IP address. | `string` | n/a | yes |
| <a name="input_backend_between_bytes_timeout"></a> [backend\_between\_bytes\_timeout](#input\_backend\_between\_bytes\_timeout) | How long to wait between bytes in milliseconds. | `number` | `10000` | no |
| <a name="input_backend_ca_cert"></a> [backend\_ca\_cert](#input\_backend\_ca\_cert) | CA cert to use when connecting to the backend. | `string` | n/a | yes |
| <a name="input_backend_first_byte_timeout"></a> [backend\_first\_byte\_timeout](#input\_backend\_first\_byte\_timeout) | How long to wait for the first bytes in milliseconds. | `number` | `15000` | no |
| <a name="input_backend_name"></a> [backend\_name](#input\_backend\_name) | Optional name for the backend. | `string` | `""` | no |
| <a name="input_backend_port"></a> [backend\_port](#input\_backend\_port) | The port number on which the Backend responds. | `number` | `443` | no |
| <a name="input_backend_ssl_check"></a> [backend\_ssl\_check](#input\_backend\_ssl\_check) | Be strict about checking SSL certs when connecting to the backend. | `bool` | `true` | no |
| <a name="input_datadog"></a> [datadog](#input\_datadog) | Whether to send logging info to Datadog | `bool` | `false` | no |
| <a name="input_datadog_region"></a> [datadog\_region](#input\_datadog\_region) | The region that log data will be sent to. | `string` | `"EU"` | no |
| <a name="input_datadog_token"></a> [datadog\_token](#input\_datadog\_token) | API key from Datadog. | `string` | `""` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | The default Time-to-live (TTL) for requests | `number` | `0` | no |
| <a name="input_dynamic_compression"></a> [dynamic\_compression](#input\_dynamic\_compression) | Whether to dynamically compress responses before sending them | `bool` | `true` | no |
| <a name="input_fastly_globeviz_url"></a> [fastly\_globeviz\_url](#input\_fastly\_globeviz\_url) | URL to send traffic data for fastly for their Global Visualization page | `string` | `""` | no |
| <a name="input_force_tls_hsts"></a> [force\_tls\_hsts](#input\_force\_tls\_hsts) | Force TLS and HTTP Strict Transport Security (HSTS) to ensure that every request is secure. | `bool` | `true` | no |
| <a name="input_globeviz_service"></a> [globeviz\_service](#input\_globeviz\_service) | Enables sending traffic information to Fastly's Globeviz page using the given service. | `string` | `""` | no |
| <a name="input_gzip_default_policy"></a> [gzip\_default\_policy](#input\_gzip\_default\_policy) | Whether to enable Fastly's default gzip policy | `bool` | `false` | no |
| <a name="input_healthcheck_expected_response"></a> [healthcheck\_expected\_response](#input\_healthcheck\_expected\_response) | Response to expect from a healthy endpoint. | `number` | `200` | no |
| <a name="input_healthcheck_host"></a> [healthcheck\_host](#input\_healthcheck\_host) | Host to ping for healthcheck. Defaults to hostname. | `string` | `""` | no |
| <a name="input_healthcheck_method"></a> [healthcheck\_method](#input\_healthcheck\_method) | HTTP method to use when doing a healthcheck. | `string` | `"HEAD"` | no |
| <a name="input_healthcheck_name"></a> [healthcheck\_name](#input\_healthcheck\_name) | Optional name for the healthcheck. | `string` | `""` | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | URL to use when doing a healthcheck. | `string` | `"/health"` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname the service points to. | `string` | n/a | yes |
| <a name="input_hsts_duration"></a> [hsts\_duration](#input\_hsts\_duration) | Number of seconds for the client to remember only to use HTTPS. | `number` | `31557600` | no |
| <a name="input_ip_blocklist"></a> [ip\_blocklist](#input\_ip\_blocklist) | Whether to enable the IP Blocklist ACL. Must be managed externally, unless ip\_blocklist\_items is given. | `bool` | `true` | no |
| <a name="input_ip_blocklist_items"></a> [ip\_blocklist\_items](#input\_ip\_blocklist\_items) | List of IP CIDRs to block. This will make the ACL object 'managed' by terraform. | `list(string)` | `[]` | no |
| <a name="input_ip_blocklist_name"></a> [ip\_blocklist\_name](#input\_ip\_blocklist\_name) | Name for the ACL responsible for holding all the blocked IP ranges. | `string` | `"IP Block list"` | no |
| <a name="input_ja3_blocklist"></a> [ja3\_blocklist](#input\_ja3\_blocklist) | Whether to enable the JA3 Blocklist Dictionary. Must be managed externally, unless ja3\_blocklist\_items is given. | `bool` | `true` | no |
| <a name="input_ja3_blocklist_items"></a> [ja3\_blocklist\_items](#input\_ja3\_blocklist\_items) | List of JA3 hashes to block. This will make the Dictionary object 'managed' by terraform. | `list(string)` | `[]` | no |
| <a name="input_ja3_blocklist_name"></a> [ja3\_blocklist\_name](#input\_ja3\_blocklist\_name) | Name for the Dictionray responsible for holding all the blocked JA3 hashes. | `string` | `"JA3 Blocklist"` | no |
| <a name="input_mastodon_error_page"></a> [mastodon\_error\_page](#input\_mastodon\_error\_page) | Whether to enable the official mastodon error page. | `bool` | `true` | no |
| <a name="input_max_conn"></a> [max\_conn](#input\_max\_conn) | Maximum number of connections for the Backend. | `number` | `500` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | Minimum allowed TLS version on SSL connections to the backend. | `string` | `"1.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the fastly service (defaults to hostname). | `string` | `""` | no |
| <a name="input_product_enablement"></a> [product\_enablement](#input\_product\_enablement) | Which additional Fastly products to enable for this service. | <pre>object({<br>    brotli_compression = optional(bool, false)<br>    domain_inspector   = optional(bool, false)<br>    image_optimizer    = optional(bool, false)<br>    origin_inspector   = optional(bool, false)<br>    websockets         = optional(bool, false)<br>  })</pre> | <pre>{<br>  "brotli_compression": false,<br>  "domain_inspector": false,<br>  "image_optimizer": false,<br>  "origin_inspector": false,<br>  "websockets": false<br>}</pre> | no |
| <a name="input_shield_region"></a> [shield\_region](#input\_shield\_region) | Which Fastly shield region to use. Should correspond with the shield code. | `string` | n/a | yes |
| <a name="input_signal_science_host"></a> [signal\_science\_host](#input\_signal\_science\_host) | Hostname to use to integrate with Signal Sciences | `string` | `""` | no |
| <a name="input_signal_science_shared_key"></a> [signal\_science\_shared\_key](#input\_signal\_science\_shared\_key) | Shared key to use when integrating with Signal Sciences | `string` | `""` | no |
| <a name="input_ssl_hostname"></a> [ssl\_hostname](#input\_ssl\_hostname) | Hostname to use for SSL verification (if different from 'hostname'). | `string` | `""` | no |
| <a name="input_tarpit"></a> [tarpit](#input\_tarpit) | Whether to enable tarpit (anti-abuse rate limiting). | `bool` | `true` | no |
| <a name="input_use_ssl"></a> [use\_ssl](#input\_use\_ssl) | Whether or not to use SSL to reach the Backend. | `bool` | `true` | no |
| <a name="input_vcl_snippets"></a> [vcl\_snippets](#input\_vcl\_snippets) | Additional custom VCL snippets to add to the service. | <pre>list(object({<br>    content  = string<br>    name     = string<br>    type     = string<br>    priority = optional(number, 100)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_version"></a> [active\_version](#output\_active\_version) | The currently active version of the Fastly Service |
| <a name="output_as_blocklist_dictionary_id"></a> [as\_blocklist\_dictionary\_id](#output\_as\_blocklist\_dictionary\_id) | ID of the AS blocklist dictionary |
| <a name="output_as_request_blocklist_dictionary_id"></a> [as\_request\_blocklist\_dictionary\_id](#output\_as\_request\_blocklist\_dictionary\_id) | ID of the AS request blocklist dictionary |
| <a name="output_cloned_version"></a> [cloned\_version](#output\_cloned\_version) | The latest cloned version by the provider |
| <a name="output_id"></a> [id](#output\_id) | The ID of this resource |
| <a name="output_ip_blocklist_acl_id"></a> [ip\_blocklist\_acl\_id](#output\_ip\_blocklist\_acl\_id) | ID of the IP blocklist ACL |
| <a name="output_ja3_blocklist_dictionary_id"></a> [ja3\_blocklist\_dictionary\_id](#output\_ja3\_blocklist\_dictionary\_id) | ID of the JA3 blocklist dictionary |

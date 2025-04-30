variable "name" {
  description = "Name of the fastly service (defaults to hostname)."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname the service points to."
  type        = string
}

variable "domains" {
  description = "Additional domains to assign to this service"
  type        = list(string)
  default     = []
}

variable "ssl_hostname" {
  description = "Hostname to use for SSL verification (if different from 'hostname')."
  type        = string
  default     = ""
}

variable "default_ttl" {
  description = "The default Time-to-live (TTL) for requests"
  type        = number
  default     = 0
}

variable "backend_name" {
  description = "Optional name for the backend."
  type        = string
  default     = ""
}

variable "backend_address" {
  description = "Address to use for connecting to the backend. Can be a hostname or an IP address."
  type        = string
}

variable "backend_port" {
  description = "The port number on which the Backend responds."
  type        = number
  default     = 443
}

variable "backend_ssl_check" {
  description = "Be strict about checking SSL certs when connecting to the backend."
  type        = bool
  default     = true
}

variable "backend_ca_cert" {
  description = "CA cert to use when connecting to the backend."
  type        = string
  sensitive   = true
}

variable "backend_first_byte_timeout" {
  description = "How long to wait for the first bytes in milliseconds."
  type        = number
  default     = 15000
}

variable "backend_between_bytes_timeout" {
  description = "How long to wait between bytes in milliseconds."
  type        = number
  default     = 10000
}

variable "max_conn" {
  description = "Maximum number of connections for the Backend."
  type        = number
  default     = 500
}

variable "min_tls_version" {
  description = "Minimum allowed TLS version on SSL connections to the backend."
  type        = string
  default     = "1.2"
}

variable "use_ssl" {
  description = "Whether or not to use SSL to reach the Backend."
  type        = bool
  default     = true
}

variable "shield_region" {
  description = "Which Fastly shield region to use. Should correspond with the shield code."
  type        = string
}

variable "media_backend" {
  description = "Additional backend to use for service media files"
  type = object({
    address        = string
    name           = optional(string, "")
    condition      = optional(string, "")
    condition_name = optional(string, "Media backend condition")
    ssl_check      = optional(bool, true)
    ssl_hostname   = optional(string, "")
    bucket_prefix  = optional(string, "")
  })
  default = { address = "" }
}

variable "healthcheck_host" {
  description = "Host to ping for healthcheck. Defaults to hostname."
  type        = string
  default     = ""
}

variable "healthcheck_name" {
  description = "Optional name for the healthcheck."
  type        = string
  default     = ""
}

variable "healthcheck_path" {
  description = "URL to use when doing a healthcheck."
  type        = string
  default     = "/health"
}

variable "healthcheck_method" {
  description = "HTTP method to use when doing a healthcheck."
  type        = string
  default     = "HEAD"

  validation {
    condition     = contains(["CONNECT", "DELETE", "GET", "HEAD", "OPTIONS", "POST", "PUT", "TRACE"], var.healthcheck_method)
    error_message = "Healthcheck method must be a valid HTTP method"
  }
}

variable "force_tls_hsts" {
  description = "Force TLS and HTTP Strict Transport Security (HSTS) to ensure that every request is secure."
  type        = bool
  default     = true
}

variable "hsts_duration" {
  description = "Number of seconds for the client to remember only to use HTTPS."
  type        = number
  default     = 31557600
}

variable "healthcheck_expected_response" {
  description = "Response to expect from a healthy endpoint."
  type        = number
  default     = 200
}

variable "datadog" {
  description = "Whether to send logging info to Datadog"
  type        = bool
  default     = false
}

variable "datadog_token" {
  description = "API key from Datadog."
  type        = string
  default     = ""
  sensitive   = true
}

variable "datadog_service" {
  description = "Datadog service name to use for logs"
  type        = string
  default     = "fastly"
}

variable "datadog_region" {
  description = "The region that log data will be sent to."
  type        = string
  default     = "EU"

  validation {
    condition     = contains(["US", "EU"], var.datadog_region)
    error_message = "Datadog region must be either US or EU."
  }
}

variable "android_deep_link" {
  description = "Enable assets for Android deep link"
  type        = bool
  default     = true
}

variable "fastly_globeviz_url" {
  description = "URL to send traffic data for fastly for their Global Visualization page"
  type        = string
  default     = ""
}

variable "apex_redirect" {
  description = "Enable Fastly Apex redirection"
  type        = bool
  default     = true
}

variable "static_cache_control" {
  description = "Add cache-control headers for static files"
  type        = bool
  default     = true
}

variable "mastodon_error_page" {
  description = "Whether to enable the official mastodon error page."
  type        = bool
  default     = true
}

variable "tarpit" {
  description = "Whether to enable tarpit (anti-abuse rate limiting)."
  type        = bool
  default     = true
}

variable "apple_associated_domain" {
  description = "Enable associated domain for Apple apps"
  type        = bool
  default     = true
}

variable "vary_accept_language" {
  description = "Whether to set 'Vary: Accept-Language' as a header with language-specific pages"
  type        = bool
  default     = true
}

variable "vcl_snippets" {
  description = "Additional custom VCL snippets to add to the service."
  type = list(object({
    content  = string
    name     = string
    type     = string
    priority = optional(number, 100)
  }))
  default = []
}

variable "edge_security" {
  description = "Whether to enable the Edge Security blocklist."
  type        = bool
  default     = true
}

variable "gzip_default_policy" {
  description = "Whether to enable Fastly's default gzip policy"
  type        = bool
  default     = false
}

variable "dynamic_compression" {
  description = "Whether to dynamically compress responses before sending them"
  type        = bool
  default     = true
}

variable "product_enablement" {
  description = "Which additional Fastly products to enable for this service."
  type = object({
    brotli_compression = optional(bool, false)
    domain_inspector   = optional(bool, false)
    image_optimizer    = optional(bool, false)
    origin_inspector   = optional(bool, false)
    websockets         = optional(bool, false)
  })
  default = {
    brotli_compression = false
    domain_inspector   = false
    image_optimizer    = false
    origin_inspector   = false
    websockets         = false
  }
}

variable "purge_auth" {
  description = "Whether to require API tokens when subimtting HTTP PURGE requests"
  type        = bool
  default     = true
}

# IP block lists

variable "ip_blocklist" {
  description = "Whether to enable the IP Blocklist ACL. Must be managed externally, unless ip_blocklist_items is given."
  type        = bool
  default     = true
}

variable "ip_blocklist_items" {
  description = "List of IP CIDRs to block. This will make the ACL object 'managed' by terraform."
  type        = list(string)
  default     = []

  validation {
    condition     = can([for s in var.ip_blocklist_items : regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", s)])
    error_message = "Each list item must be in a CIDR block format. Example: [\"10.106.108.0/25\"]."
  }
}

variable "ip_blocklist_name" {
  description = "Name for the ACL responsible for holding all the blocked IP ranges."
  type        = string
  default     = "IP Block list"
}

# AS block lists

variable "as_blocklist" {
  description = "Whether to enable the AS blocklist ACLs. Must be managed externally, unless as_blocklist_items is given."
  type        = bool
  default     = true
}

variable "as_blocklist_items" {
  description = "List of Autonomous Systems (AS) to block. This will make the Dictionary object 'managed' by terraform."
  type        = list(number)
  default     = []
}

variable "as_blocklist_name" {
  description = "Name of the AS blocklist"
  type        = string
  default     = "AS Blocklist"
}

variable "as_request_blocklist_items" {
  description = "List of Autonomous Systems (AS) to block from making /api or /explore requests. This will make the Dictionary object 'managed' by terraform."
  type        = list(number)
  default     = []
}

variable "as_request_blocklist_name" {
  description = "Name of the AS request blocklist"
  type        = string
  default     = "AS Requests Blocklist"
}

# JA3 block list

variable "ja3_blocklist" {
  description = "Whether to enable the JA3 Blocklist Dictionary. Must be managed externally, unless ja3_blocklist_items is given."
  type        = bool
  default     = true
}

variable "ja3_blocklist_items" {
  description = "List of JA3 hashes to block. This will make the Dictionary object 'managed' by terraform."
  type        = list(string)
  default     = []
}

variable "ja3_blocklist_name" {
  description = "Name for the Dictionray responsible for holding all the blocked JA3 hashes."
  type        = string
  default     = "JA3 Blocklist"
}

# Signal Sciences

variable "signal_science_host" {
  description = "Hostname to use to integrate with Signal Sciences"
  type        = string
  default     = ""
}

variable "signal_science_shared_key" {
  description = "Shared key to use when integrating with Signal Sciences"
  type        = string
  default     = ""
}

# Globeviz

variable "globeviz_service" {
  description = "Enables sending traffic information to Fastly's Globeviz page using the given service."
  type        = string
  default     = ""
}

variable "name" {
  description = "Name of the fastly service (defaults to hostname)."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname the service points to."
  type        = string
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

variable "datadog_token" {
  description = "API key from Datadog."
  type        = string
  default     = ""
  sensitive   = true
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

variable "vcl_snippets" {
  description = "Additional custom VCL snippets to add to the service."
  type        = list(object({
    content  = string
    name     = string
    type     = string
    priority = optional(number, 100)
  }))
  default = []
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

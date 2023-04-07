# Basic service

variable "name" {
  description = "Name of the Fastly service itself"
  type        = string
}

variable "domains" {
  description = "A set of Domain names to serve as entry points for your Service."
  type = list(object({
    name    = string
    comment = optional(string, "")
  }))
}

variable "activate" {
  description = "Conditionally prevents the Service from being activated. The apply step will continue to create a new draft version but will not activate it if this is set to false."
  type        = bool
  default     = true
}

variable "default_ttl" {
  description = "The default Time-to-live (TTL) for requests."
  type        = number
  default     = 300
}

variable "http3" {
  description = "Enables support for the HTTP/3 (QUIC) protocol."
  type        = bool
  default     = true
}

variable "force_tls_enable_hsts" {
  description = "Force TLS and HTTP Strict Transport Security (HSTS). Creates necessary objects in a similar fashion to the GUI flag."
  type        = bool
  default     = true
}

variable "hsts_duration" {
  description = "How long the client should remember that the domain uses HSTS"
  type        = number
  default     = 31557600
}

variable "stale_if_error" {
  description = "Enables serving a stale object if there is an error."
  type        = bool
  default     = true
}

# Backends
variable "backends" {
  description = "All backends that will be used for this service."
  type = list(object({
    name    = string
    address = string

    auto_loadbalance  = optional(bool, true)
    healthcheck       = optional(string, "")
    max_conn          = optional(number, 200)
    max_tls_version   = optional(string, "")
    min_tls_version   = optional(string, "1.2")
    port              = optional(number, 443)
    shield            = optional(string, "")
    ssl_ca_cert       = optional(string, "")
    ssl_cert_hostname = optional(string, "")
    ssl_sni_hostname  = optional(string, "")
    override_host     = optional(string, "")
    use_ssl           = optional(bool, true)
  }))
  default = []
}

variable "backend_ssl_ca_cert" {
  description = "CA certificate attached to origin. Used to pull value from Terraform Cloud."
  type        = string
  sensitive   = true
  default     = ""
}

# Healthcheck endpoints.
variable "healthchecks" {
  description = "Endpoints to periodically test for backend health."
  type = list(object({
    name = string
    host = string
    path = optional(string, "/health")

    check_interval    = optional(number, 60000)
    expected_response = optional(number, 200)
    headers           = optional(list(string), [])
    http_version      = optional(string, "1.1")
    initial           = optional(number, 1)
    method            = optional(string, "GET")
    threshold         = optional(number, 1)
    timeout           = optional(number, 5000)
    window            = optional(number, 2)
  }))
  default = []
}

# Custom headers
variable "headers" {
  description = "Headers to attach to HTTP responses. Automatically generates condition objects."
  type = list(object({
    name        = string
    action      = string
    destination = string
    type        = string

    cache_condition             = optional(string, "")
    ignore_if_set               = optional(bool, false)
    priority                    = optional(number, 100)
    regex                       = optional(string, "")
    request_condition           = optional(string, "")
    request_condition_type      = optional(string, "REQUEST")
    request_condition_priority  = optional(number, 10)
    response_condition          = optional(string, "")
    response_condition_type     = optional(string, "REQUEST")
    response_condition_priority = optional(number, 10)
    source                      = optional(string, "")
    substitution                = optional(string, "")
  }))
  default = []
}

# Datadog logging
variable "logging_datadog" {
  description = "Datalog connection and logging information."
  type = object({
    name = string

    token  = optional(string, "")
    format = optional(string, "")
    region = optional(string, "EU")
  })
  sensitive = true
  default   = null
}

variable "logging_datadog_token" {
  description = "API key from Datadog. Used to pull value from Terraform Cloud."
  type        = string
  sensitive   = true
  default     = ""
}

# Custom VCL snippets
variable "snippets" {
  description = "Custom VCL snippets to insert."
  type = list(object({
    name     = string
    content  = string
    type     = string
    priority = optional(number, 100)
  }))
  default = []
}

# Custom response objects
variable "responses" {
  description = "Custom response objects. Automatically generates condition objects."
  type = list(object({
    name               = string
    content            = string
    content_type       = string
    condition          = string
    condition_type     = string
    condition_priority = optional(number, 10)
    response           = string
    status             = string
  }))
  default = []
}

# IP block lists

variable "ip_blocklist" {
  description = "List of IP CIDR blocks to deny access."
  type        = list(string)
  default     = []

  validation {
    condition     = can([for s in var.ip_blocklist : regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", s)])
    error_message = "Each list item must be in a CIDR block format. Example: [\"10.106.108.0/25\"]."
  }
}

variable "ip_blocklist_acl_name" {
  description = "Name for the ACL responsible for holding all the blocked IP ranges."
  type        = string
  default     = "IP Block list"
}

variable "products" {
  description = "List of additional Fastly products to enable on the service."
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

# AS block lists

variable "as_blocklist" {
  description = "List of Autonomous Systems (AS) to block."
  type        = list(number)
  default     = []
}

variable "as_blocklist_name" {
  description = "Name of the AS blocklist"
  type        = string
  default     = "Blocked AS Numbers"
}

variable "as_request_blocklist" {
  description = "List of Autonomous Systems (AS) to block from making /api or /explore requests."
  type        = list(number)
  default     = []
}

variable "as_request_blocklist_name" {
  description = "Name of the AS blocklist"
  type        = string
  default     = "Blocked AS Numbers client requests"
}

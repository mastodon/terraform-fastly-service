variable "hostname" {
  description = "Hostname the service points to."
  type        = string
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

variable "backend_ca_cert" {
  description = "CA cert to use when connecting to the backend."
  type        = string
  sensitive   = true
}

variable "shield_region" {
  description = "Which Fastly shield region to use. Should correspond with the shield code."
  type        = string
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

variable "datadog_token" {
  description = "API key from Datadog."
  type        = string
  sensitive   = true
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
  description = "Name of the AS request blocklist"
  type        = string
  default     = "Blocked AS Numbers client requests"
}

# Signal Sciences

variable "signal_science_host" {
  description = "Hostname to use to integrate with Signal Sciences"
  type        = string
}

variable "signal_science_shared_key" {
  description = "Shared key to use when integrating with Signal Sciences"
  type        = string
}

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

variable "files_backend_name" {
  description = "Optional name for the files backend."
  type        = string
  default     = ""
}

variable "files_backend_address" {
  description = "Address to use for connecting to the files backend. Can be a hostname or an IP address."
  type        = string
}

variable "files_shield_region" {
  description = "Which Fastly shield region to use for the files service. Should correspond with the shield code."
  type        = string
}

variable "datadog_token" {
  description = "API key from Datadog."
  type        = string
  sensitive   = true
}

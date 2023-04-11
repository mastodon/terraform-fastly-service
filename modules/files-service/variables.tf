variable "hostname" {
  description = "Hostname the service points to."
  type        = string
}

variable "app_hostname" {
  description = "Hostname of the mastodon app that this service belongs to."
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

variable "shield_region" {
  description = "Which Fastly shield region to use. Should correspond with the shield code."
  type        = string
}

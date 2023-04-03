terraform {
  required_version = ">= 1.0.0"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 4.1.0"
    }
  }
}

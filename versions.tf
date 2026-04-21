terraform {
  required_version = ">= 1.0.0"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 9.0.0"
    }
  }
}

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 4.1.0"
    }
  }
}

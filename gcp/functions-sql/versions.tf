terraform {
  required_version = ">= 0.12.25, < 0.13"
  required_providers {
    google = ">= 3.22, < 4.0"
    null   = "~> 2.1"
    random = "~> 2.2"
  }
}

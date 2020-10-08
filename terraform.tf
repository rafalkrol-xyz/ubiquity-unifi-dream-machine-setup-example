terraform {
  required_version = "~> 0.13.0"

  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "0.15.0-beta.2"
    }
  }
}

provider "unifi" {
  username       = var.username
  password       = var.password
  api_url        = var.api_url
  allow_insecure = true
}

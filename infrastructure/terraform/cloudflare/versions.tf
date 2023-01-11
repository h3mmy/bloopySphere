terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.32.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.28.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

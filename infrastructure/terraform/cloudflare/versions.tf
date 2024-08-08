terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.39.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
  }
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.12.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }
}

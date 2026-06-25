terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.21.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.6.0"
    }
  }
}

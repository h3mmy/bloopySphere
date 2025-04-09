terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.3.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}

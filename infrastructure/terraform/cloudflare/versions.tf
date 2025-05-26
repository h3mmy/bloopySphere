terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.49.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }
}

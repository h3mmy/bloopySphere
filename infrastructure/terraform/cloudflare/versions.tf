terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.52.5"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }
}

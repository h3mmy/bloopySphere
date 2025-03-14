terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.49.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}

terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
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

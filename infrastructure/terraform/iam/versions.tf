terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
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

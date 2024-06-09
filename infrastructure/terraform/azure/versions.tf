terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }
  }
}

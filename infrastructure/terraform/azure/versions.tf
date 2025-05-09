terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.28.0"
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

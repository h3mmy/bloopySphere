terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.70.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
  }
}

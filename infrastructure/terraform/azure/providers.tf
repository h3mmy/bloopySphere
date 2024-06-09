provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  client_id       = local.azurerm_secrets["azure_tf_client_id"]
  client_secret   = local.azurerm_secrets["azure_tf_client_secret"]
  subscription_id = local.azurerm_secrets["azure_subscription_id"]
  tenant_id       = local.azurerm_secrets["azure_tenant_id"]
}

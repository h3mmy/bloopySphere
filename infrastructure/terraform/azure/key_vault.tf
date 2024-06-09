resource "azurerm_key_vault" "bloopnet" {
  name                        = "bloopnet"
  location                    = azurerm_resource_group.edge_bloopy.location
  resource_group_name         = azurerm_resource_group.edge_bloopy.name
  enabled_for_disk_encryption = true
  enabled_for_deployment = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 60
  purge_protection_enabled    = false
  sku_name = "standard"
  enable_rbac_authorization = true
  enabled_for_template_deployment = true
}

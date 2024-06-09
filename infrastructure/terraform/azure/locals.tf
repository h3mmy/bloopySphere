locals {
  azurerm_secrets = sensitive(yamldecode(nonsensitive(data.sops_file.azurerm_secrets.raw)))
  domains            = yamldecode(nonsensitive(data.sops_external.domains.raw))
}

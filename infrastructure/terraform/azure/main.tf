data "sops_file" "azurerm_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_external" "domains" {
  source = data.http.bloopysphere_domains.response_body
  input_type = "yaml"
}

data "http" "bloopysphere_domains" {
  url = "https://raw.githubusercontent.com/h3mmy/bloopysphere/main/infrastructure/shared/domains.sops.yaml"
}

data "azurerm_client_config" "current" {}

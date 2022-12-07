

data "sops_file" "cloudflare_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_external" "domains" {
  source_file = data.http.bloopysphere_domains.response_body
  input_type = "yaml"
}

data "http" "bloopysphere_domains" {
  url = "https://raw.githubusercontent.com/h3mmy/bloopysphere/main/infrastructure/shared/domains.sops.yaml"
}

# Obtain current home IPv4 address
data "http" "ipv4_lookup_raw" {
  url = "http://ipv4.icanhazip.com"
}

# Obtain current home IPv6 address
# data "http" "ipv6_lookup_raw" {
#   url = "https://ipv6.icanhazip.com"
# }

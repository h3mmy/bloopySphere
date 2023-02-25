data "sops_file" "cloudflare_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_file" "domains" {
  source_file = "domains.sops.yaml"
}

# Obtain current home IPv4 address
data "http" "ipv4_lookup_raw" {
  url = "http://ipv4.icanhazip.com"
}

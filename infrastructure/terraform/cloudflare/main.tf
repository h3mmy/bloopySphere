data "sops_file" "cloudflare_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_external" "domains" {
  source = data.http.bloopysphere_domains.response_body
  input_type = "yaml"
}

data "http" "bloopysphere_domains" {
  url = "https://raw.githubusercontent.com/h3mmy/bloopysphere/main/infrastructure/shared/domains.sops.yaml"
}


# Obtain current home IPv4 address
data "http" "ipv4_lookup_raw" {
  url = "http://ipv4.icanhazip.com"
}

resource "cloudflare_email_routing_address" "tyg3r_1" {
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  email      = local.cloudflare_secrets["tyg3r_dest_email"]
}

resource "cloudflare_email_routing_address" "xyz_1" {
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  email      = local.cloudflare_secrets["xyz_0_dest_email"]
}

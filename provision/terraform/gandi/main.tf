terraform {

  required_providers {
    gandi = {
      source  = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

data "sops_file" "gandi_secrets" {
  source_file = "secret.sops.yaml"
}

provider "gandi" {
  key = data.sops_file.gandi_secrets.data["gandi_apikey"]
}

data "gandi_domain" "gandi_livedns_domain" {
    name = data.sops_file.gandi_secrets.data["gandi_domain"]
}

# resource "gandi_zone_settings_override" "gandi_settings" {
#   zone_id = lookup(data.gandi_zones.domain.zones[0], "id")
#   settings {
#     # /ssl-tls
#     ssl = "strict"
#     # /ssl-tls/edge-certificates
#     always_use_https         = "on"
#     min_tls_version          = "1.0"
#     opportunistic_encryption = "on"
#     tls_1_3                  = "zrt"
#     automatic_https_rewrites = "on"
#     universal_ssl            = "on"
#     # /firewall/settings
#     browser_check  = "on"
#     challenge_ttl  = 1800
#     privacy_pass   = "on"
#     security_level = "medium"
#     # /speed/optimization
#     brotli = "on"
#     minify {
#       css  = "on"
#       js   = "on"
#       html = "on"
#     }
#     rocket_loader = "on"
#     # /caching/configuration
#     always_online    = "off"
#     development_mode = "off"
#     # /network
#     http3               = "on"
#     zero_rtt            = "on"
#     ipv6                = "on"
#     websockets          = "on"
#     opportunistic_onion = "on"
#     pseudo_ipv4         = "off"
#     ip_geolocation      = "on"
#     # /content-protection
#     email_obfuscation   = "on"
#     server_side_exclude = "on"
#     hotlink_protection  = "off"
#     # /workers
#     security_header {
#       enabled = false
#     }
#   }
# }

data "http" "ipv4" {
  url = "http://ipv4.icanhazip.com"
}

resource "gandi_livedns_record" "ipv4" {
  name    = "ipv4"
  zone = lookup(data.gandi_domain.gandi_livedns_domain, "id")
  values   = [chomp(data.http.ipv4.body)]
  type    = "A"
  ttl     = 300
}

resource "gandi_livedns_record" "root" {
  name    = data.sops_file.gandi_secrets.data["gandi_domain"]
  zone = lookup(data.gandi_domain.gandi_livedns_domain, "id")
  values   = ["ipv4.${data.sops_file.gandi_secrets.data["gandi_domain"]}"]
  type    = "CNAME"
  ttl     = 300
}

resource "gandi_livedns_record" "hajimari" {
  name    = "hajimari"
  zone = lookup(data.gandi_domain.gandi_livedns_domain, "id")
  values   = ["ipv4.${data.sops_file.gandi_secrets.data["gandi_domain"]}"]
  type    = "CNAME"
  ttl     = 300
}

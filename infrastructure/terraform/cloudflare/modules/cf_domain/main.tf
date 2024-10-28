terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.44.0"
    }
  }
}

resource "cloudflare_zone" "zone" {
  account_id = var.account_id
  paused = "false"
  plan   = "free"
  type   = "full"
  zone   = var.domain
}

# No way to import yet
# resource "cloudflare_email_routing_settings" "email_routing_settings" {
#   depends_on = [ cloudflare_zone.zone ]
#   zone_id = cloudflare_zone.zone.id
#   enabled = var.enable_email_forwarding
# }

# Default settings for bloopysphere domains
resource "cloudflare_zone_settings_override" "cloudflare_settings" {
  zone_id = cloudflare_zone.zone.id
  settings {
    # /ssl-tls
    ssl = "full"
    # /ssl-tls/edge-certificates
    always_use_https         = "on"
    min_tls_version          = "1.2"
    opportunistic_encryption = "on"
    # zrt => 0-RTT See https://blog.cloudflare.com/introducing-0-rtt/
    tls_1_3                  = "zrt"
    automatic_https_rewrites = "on"
    universal_ssl            = "on"
    # /firewall/settings
    browser_check  = "on"
    challenge_ttl  = 1800
    privacy_pass   = "on"
    security_level = "medium"
    # /speed/optimization
    brotli = "on"
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
    rocket_loader = "on"
    # /caching/configuration
    always_online    = "off"
    development_mode = "off"
    # /network
    http3               = "on"
    zero_rtt            = "on"
    ipv6                = "on"
    websockets          = "on"
    opportunistic_onion = "on"
    pseudo_ipv4         = "off"
    ip_geolocation      = "on"
    # /content-protection
    email_obfuscation   = "on"
    server_side_exclude = "on"
    hotlink_protection  = "off"
    # /workers
    security_header {
      enabled = false
    }
  }
}

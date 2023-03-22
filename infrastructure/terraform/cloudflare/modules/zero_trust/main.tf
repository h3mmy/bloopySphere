# Inspired by https://blog.cloudflare.com/kubectl-with-zero-trust/

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.2.0"
    }
  }
}

# Make a Tunnel

resource "cloudflare_argo_tunnel" "k8s_zero_trust_tunnel" {
  account_id = var.account_id
  name       = "k8s_zero_trust_tunnel"
  secret     = var.tunnel_secret
}

# Describe one end of the tunnel

resource "cloudflare_tunnel_route" "k8s_zero_trust_tunnel_ipv4" {
  account_id = var.account_id
  tunnel_id  = cloudflare_argo_tunnel.k8s_zero_trust_tunnel.id
  network    = var.api_ipv4
  comment    = "Kubernetes API Server (IPv4)"
}

# resource "cloudflare_tunnel_route" "k8s_zero_trust_tunnel_ipv6" {
#   account_id = var.account_id
#   tunnel_id  = cloudflare_argo_tunnel.k8s_zero_trust_tunnel.id
#   network    = var.api_ipv6
#   comment    = "Kubernetes API Server (IPv6)"
# }

# Gateway Settings (for other end)

resource "cloudflare_teams_list" "k8s_apiserver_ips" {
  account_id = var.account_id
  name       = "Kubernetes API IPs"
  type       = "IP"
#   items      = [var.api_ipv4, var.api_ipv6]
  items = [var.api_ipv4]
}

resource "cloudflare_teams_rule" "k8s_apiserver_zero_trust_http" {
  account_id  = var.account_id
  name        = "Don't inspect Kubernetes API"
  description = "Allow connections from kubectl to API"
  precedence  = 10000
  action      = "off"
  enabled     = true
  filters     = ["http"]
  traffic     = format("any(http.conn.dst_ip[*] in $%s)", replace(cloudflare_teams_list.k8s_apiserver_ips.id, "-", ""))
}


# azureAD
resource "cloudflare_access_identity_provider" "azure_ad" {
  account_id = var.account_id
  name       = "Azure AD"
  type       = "azureAD"
  config {
    directory_id = var.az_directory_id
    client_secret = var.az_application_secret
    client_id = var.az_application_id
    pkce_enabled = true
    support_groups = true
  }
}

# Application
resource "cloudflare_access_application" "bloopysphere_k8s_api" {
  zone_id                   = var.zone_id
  name                      = "Bloopysphere k8s"
  domain                    = "${var.api_cname}.${var.api_domain_name}"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

# This won't work unless there is an ingress rule as well (as a kubernetes resource)
resource "cloudflare_record" "foobar" {
  zone_id = var.zone_id
  name    = var.api_cname
  value   = "${cloudflare_argo_tunnel.k8s_zero_trust_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 3600
}

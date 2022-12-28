# Inspired by https://blog.cloudflare.com/kubectl-with-zero-trust/

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.31.0"
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

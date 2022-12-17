output "tunnel_id" {
    value = cloudflare_argo_tunnel.k8s_zero_trust_tunnel.id
    description = "Tunnel ID for created tunnel. Needed for kubernetes config."
}

output "tunnel_cname" {
    value = cloudflare_argo_tunnel.k8s_zero_trust_tunnel.cname
    description = "CNAME for accessing the tunnel"
}

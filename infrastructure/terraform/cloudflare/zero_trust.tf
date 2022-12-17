# Can be used for generating dynamic secret
# Alternatively use
# openssl rand --base64 35
# resource "random_id" "my_tunnel_secret" {
#   byte_length = 35
# }

module "zero_trust_bloopysphere" {
    source = "./modules/zero_trust"
    account_id = local.cloudflare_secrets["cloudflare_account_id"]
    api_ipv4 = local.kube_api_ipv4
    tunnel_secret = local.cloudflare_secrets["cloudflare_tunnel_secret"]
}

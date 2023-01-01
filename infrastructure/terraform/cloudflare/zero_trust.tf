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
    az_application_id = local.cloudflare_secrets["azure_app_id"]
    az_application_secret = local.cloudflare_secrets["azure_client_secret"]
    az_directory_id = local.cloudflare_secrets["azure_directory_id"]
    api_cname = local.kube_api_cname
    api_domain_name = "${local.domains["xyz"]}"
    zone_id = module.cf_domain_xyz.zone_id
}

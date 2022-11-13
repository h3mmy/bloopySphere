provider "cloudflare" {
  api_token = local.cloudflare_secrets["cloudflare_apitoken"]
}

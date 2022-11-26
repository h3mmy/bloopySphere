module "cf_domain_dev" {
  source               = "./modules/cf_domain"
  domain               = local.domains["dev"]
  cloudflare_api_token = local.cloudflare_secrets["cloudflare_apitoken"]
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  dns_entries = [
    {
      id      = "status_v4"
      name    = "status"
      value   = local.status_dev_ipv4
      type    = "A"
      proxied = true
    },
    {
      id      = "status_v6"
      name    = "status"
      value   = local.status_dev_ipv6
      type    = "AAAA"
      proxied = true
    },
    {
      name    = "${local.domains["dev"]}"
      value   = "${local.gitlab_repo}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "www"
      value   = "${local.domains["dev"]}"
      type    = "CNAME"
      proxied = true
    },
    # Generic settings
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none; rua=mailto:${local.cloudflare_secrets["dmarc_rua_email"]}"
      type  = "TXT"
    },
    {
      name      = "_gitlab-pages-verification-code.${local.domains["dev"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "gitlab-pages-verification-code=e1f5ccb7dd40b649ed646ac3ed122847"
    },
    {
      id        = "firebase_id"
      name      = "${local.domains["dev"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "firebase=bloopysphere"
    },
    {
      id        = "firebase_spf"
      name      = "${local.domains["dev"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:_spf.firebasemail.com ~all"
    },
    {
      name      = "firebase1._domainkey.${local.domains["dev"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "mail-bloopnet-dev.dkim1._domainkey.firebasemail.com"
    },
    {
      name      = "firebase2._domainkey.${local.domains["dev"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "mail-bloopnet-dev.dkim2._domainkey.firebasemail.com"
    },
    {
      name      = "_domainconnect.${local.domains["dev"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "connect.domains.google.com"
    }
  ]
}

# Actually belongs to cf_domain_dev but I made a mistake
# resource "cloudflare_workers_kv_namespace" "cf_domain_xyz_status_kv_ns" {
#   title = "KV_STATUS_PAGE"
# }

# Actually belongs to cf_domain_dev but I made a mistake
# resource "cloudflare_workers_kv_namespace" "cf_domain_xyz_static_kv_ns" {
#   title = "__STATIC_CONTENT"
# }

resource "cloudflare_worker_route" "cf_domain_dev_status_route" {
  zone_id     = module.cf_domain_dev.zone_id
  pattern     = "status.${local.domains["dev"]}/*"
  script_name = "leafybloop-production"
  # script_name = cloudflare_worker_script.status_dev_script.name
}

# Sets the script with the name "script_1"
# resource "cloudflare_worker_script" "status_dev_script" {
#   name = "leafybloop-production"

#   kv_namespace_binding {
#     name         = cloudflare_workers_kv_namespace.cf_domain_xyz_status_kv_ns.title
#     namespace_id = cloudflare_workers_kv_namespace.cf_domain_xyz_status_kv_ns.id
#   }

#   kv_namespace_binding {
#     name         = cloudflare_workers_kv_namespace.cf_domain_xyz_static_kv_ns.title
#     namespace_id = cloudflare_workers_kv_namespace.cf_domain_xyz_static_kv_ns.id
#   }

  # text_blob_binding {
  #   name = "__STATIC_CONTENT_MANIFEST"
  # }

  # Unused
  # secret_text_binding {
  #   name = "SECRET_DISCORD_WEBHOOK_URL"
  # }
  # secret_text_binding {
  #   name = "SECRET_SLACK_WEBHOOK_URL"
  # }
  # secret_text_binding {
  #   name = "SECRET_TELEGRAM_API_TOKEN"
  # }
  # secret_text_binding {
  #   name = "SECRET_TELEGRAM_CHAT_ID"
  # }
#
# }

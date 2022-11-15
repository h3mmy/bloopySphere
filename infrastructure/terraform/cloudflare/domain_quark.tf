module "cf_domain_quark" {
  source               = "./modules/cf_domain"
  domain               = local.domains["quark"]
  cloudflare_api_token = local.cloudflare_secrets["cloudflare_apitoken"]
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  dns_entries = [
    {
      name    = "bloop"
      value   = local.cloudflare_secrets["bloopysphere_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      name    = "neutrino"
      value   = local.cloudflare_secrets["oci_neutrino_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      name    = "in"
      value   = local.cloudflare_secrets["oci_lb_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      name    = "${local.domains["quark"]}"
      value   = "in.${local.domains["quark"]}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "*"
      value   = "${local.domains["quark"]}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "www"
      value   = "${local.domains["quark"]}"
      type    = "CNAME"
      proxied = true
    },
    # Generic settings
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none; rua=mailto:${local.cloudflare_secrets["dmarc_rua_email"]}"
      type  = "TXT"
    },
    # Google
    {
      id = "google_verify"
      name      = "${local.domains["quark"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "google-site-verification=NkkNk23Voa4Boqjzii55n12QzCaqDsuusju-hxy34pY"
    },
    {
      id        = "google_mx_3"
      name      = "${local.domains["quark"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "alt3.aspmx.l.google.com"
    },
    {
      id        = "google_mx_0"
      name      = "${local.domains["quark"]}"
      priority  = 1
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "aspmx.l.google.com"
    },
    {
      id        = "google_mx_2"
      name      = "${local.domains["quark"]}"
      priority  = 5
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "alt2.aspmx.l.google.com"
    },
    {
      id        = "google_mx_1"
      name      = "${local.domains["quark"]}"
      priority  = 5
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "alt1.aspmx.l.google.com"
    },
    {
      id        = "google_mx_4"
      name      = "${local.domains["quark"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "alt4.aspmx.l.google.com"
    },
    # Gandi
    {
      id        = "gandi_spf"
      name      = "${local.domains["quark"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:_mailcust.gandi.net include:_spf.google.com ?all"
    },
    {
      id        = "gandi_webmail"
      name      = "webmail.${local.domains["quark"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "webmail.gandi.net"
    },
    # OCI
    {
      id        = "oci_domain_verification"
      name      = "${local.domains["quark"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "oci-domain-verification=ZTjjyzPYPIcoObkVMmCmjoKtE92Tha1UUOymdAS3Ae9"
    }
  ]
}

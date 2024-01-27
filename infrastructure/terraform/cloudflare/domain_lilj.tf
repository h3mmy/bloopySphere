module "cf_domain_lilj" {
  source               = "./modules/cf_domain"
  domain               = local.domains["lilj"]
  cloudflare_api_token = local.cloudflare_secrets["cloudflare_apitoken"]
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  enable_email_forwarding = true
  dns_entries = [
    {
      id      = "main_v4"
      name    = "${local.domains["lilj"]}"
      value   = local.cloudflare_secrets["bloopysphere_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      id      = "main_v6"
      name    = "${local.domains["lilj"]}"
      value   = local.cloudflare_secrets["bloopysphere_ipv6_lb"]
      type    = "AAAA"
      proxied = true
    },
    {
      name    = "www"
      value   = "${local.domains["lilj"]}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "*"
      value   = "${local.domains["lilj"]}"
      type    = "CNAME"
      proxied = true
    },
    # Generic settings
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none; rua=mailto:${local.cloudflare_secrets["dmarc_rua_email_v2"]}"
      type  = "TXT"
    },
    # Mailgun
    {
      id    = "mailgun_dkim_1"
      name  = "pic._domainkey.mg.${local.domains["lilj"]}"
      type  = "TXT"
      value = "${local.cloudflare_secrets["lilj_mailgun_dkim"]}"
    },
    {
      hostname  = "mg.${local.domains["lilj"]}"
      id        = "mailgun_spf"
      name      = "mg.${local.domains["lilj"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:mailgun.org ~all"
    },
    {
      id        = "mailgun_mx_2"
      name      = "mg.${local.domains["lilj"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "mxb.mailgun.org"
    },
    {
      id        = "mailgun_mx_1"
      name      = "mg.${local.domains["lilj"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "mxa.mailgun.org"
    },
    {
      name      = "email.mg.${local.domains["lilj"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "mailgun.org"
    },
    {
      hostname  = "${local.domains["lilj"]}"
      id        = "cloudflare_spf"
      name      = "${local.domains["lilj"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:_spf.mx.cloudflare.net ~all"
    }

  ]

  ext_dns_entries = [
    # Cloudflare MX Records are managed by email_routing resources
    {
      hostname      = "${local.domains["lilj"]}"
      priority  = 53
      type      = "MX"
      zone_id = module.cf_domain_lilj.zone_id
    },
    {
      hostname      = "${local.domains["lilj"]}"
      priority  = 26
      type      = "MX"
      zone_id = module.cf_domain_lilj.zone_id
    },
    {
      hostname      = "${local.domains["lilj"]}"
      priority  = 61
      type      = "MX"
      zone_id = module.cf_domain_lilj.zone_id
    }
  ]
}



resource "cloudflare_email_routing_catch_all" "lilj_0" {
  zone_id = module.cf_domain_lilj.zone_id
  name    = "catch_all"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "drop"
    value = []
  }
}

resource "cloudflare_email_routing_rule" "lilj_0" {
  depends_on = [ cloudflare_email_routing_address.tyg3r_1 ]
  zone_id = module.cf_domain_lilj.zone_id
  name    = "Forward to primary inbox"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "lillian@${local.domains["lilj"]}"
  }

  action {
    type  = "forward"
    value = [cloudflare_email_routing_address.tyg3r_1.email]
  }
}

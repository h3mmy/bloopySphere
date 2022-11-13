module "cf_domain_tyg3r" {
  source               = "./modules/cf_domain"
  domain               = local.domains["tyg3r"]
  cloudflare_api_token = local.cloudflare_secrets["cloudflare_apitoken"]
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  dns_entries = [
    {
      id      = "main_v4"
      name    = "${local.domains["tyg3r"]}"
      value   = local.cloudflare_secrets["bloopysphere_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      id      = "main_v6"
      name    = "${local.domains["tyg3r"]}"
      value   = local.cloudflare_secrets["bloopysphere_ipv6_lb"]
      type    = "AAAA"
      proxied = true
    },
    {
      name    = "www"
      value   = "${local.domains["tyg3r"]}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "*"
      value   = "${local.domains["tyg3r"]}"
      type    = "CNAME"
      proxied = true
    },
    # Generic settings
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none; rua=mailto:${local.cloudflare_secrets["dmarc_rua_email"]}"
      type  = "TXT"
    },
    # Mailgun
    {
      id    = "mailgun_dkim_1"
      name  = "krs._domainkey.mail"
      type  = "TXT"
      value = "k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu+cIDE0k8wG22SsknCtwDpZt8629nY78M9GmNVzz6yvOx+1qxPkqZV63GP3SdliKdO3LZ/3mkKweb9iDrvVPTDe4XfWsaMJm+rb4JiXzkIr7ehBpid/a0oZ5uRWsz1peB3jyAPVCh1IZHThU3S8JWhwvHDqubVKkgAtpRM+HU0sSbm474BPCh0zqFmSwi5L8Pz8LSID2SLqdGOHE37XxC7ivrGOiG7jaG1z4A04HQTjWGrNnP7s8nuTZe4EOBT4RkjCXyX8u3fQCnjDy66x7iI3KgjW7kJLU/s2NX55icY5ZvViA2xqOhflsb5E+m1fGC1qEOmIcZl3ksm7PgiUh6wIDAQAB"
    },
    {
      hostname  = "mail.${local.domains["tyg3r"]}"
      id        = "mailgun_spf"
      name      = "mail.${local.domains["tyg3r"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:mailgun.org ~all"
    },
    {
      id        = "mailgun_mx_2"
      name      = "mail.${local.domains["tyg3r"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "mxb.mailgun.org"
    },
    {
      id        = "mailgun_mx_1"
      name      = "mail.${local.domains["tyg3r"]}"
      priority  = 10
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "MX"
      value     = "mxa.mailgun.org"
    },
    {
      name      = "email.mail.${local.domains["tyg3r"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "mailgun.org"
    },
    {
      hostname  = "${local.domains["tyg3r"]}"
      id        = "cloudflare_spf"
      name      = "${local.domains["tyg3r"]}"
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
      hostname      = "${local.domains["tyg3r"]}"
      priority  = 25
      type      = "MX"
      zone_id = module.cf_domain_tyg3r.zone_id
    },
    {
      hostname      = "${local.domains["tyg3r"]}"
      priority  = 19
      type      = "MX"
      zone_id = module.cf_domain_tyg3r.zone_id
    },
    {
      hostname      = "${local.domains["tyg3r"]}"
      priority  = 21
      type      = "MX"
      zone_id = module.cf_domain_tyg3r.zone_id
    }
  ]
}

resource "cloudflare_email_routing_address" "tyg3r_0" {
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  email      = local.cloudflare_secrets["tyg3r_dest_email"]
}

resource "cloudflare_email_routing_catch_all" "tyg3r_0" {
  zone_id = module.cf_domain_tyg3r.zone_id
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

resource "cloudflare_email_routing_rule" "main" {
  zone_id = module.cf_domain_tyg3r.zone_id
  name    = "Forward to primary inbox"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "lily@${local.domains["tyg3r"]}"
  }

  action {
    type  = "forward"
    value = ["${local.cloudflare_secrets["tyg3r_dest_email"]}"]
  }
}

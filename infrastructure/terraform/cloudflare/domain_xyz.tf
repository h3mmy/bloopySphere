module "cf_domain_xyz" {
  source               = "./modules/cf_domain"
  domain               = local.domains["xyz"]
  cloudflare_api_token = local.cloudflare_secrets["cloudflare_apitoken"]
  account_id           = local.cloudflare_secrets["cloudflare_account_id"]
  dns_entries = [
    {
      id      = "in_v4"
      name    = "in"
      value   = local.cloudflare_secrets["bloopysphere_ipv4"]
      type    = "A"
      proxied = true
    },
    {
      id      = "in_v6"
      name    = "in"
      value   = local.cloudflare_secrets["bloopysphere_ipv6_lb"]
      type    = "AAAA"
      proxied = true
    },
    {
      name    = "${local.domains["xyz"]}"
      value   = "in.${local.domains["xyz"]}"
      type    = "CNAME"
      proxied = true
    },
    {
      name    = "*"
      value   = "in.${local.domains["xyz"]}"
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
      id        = "ba6871784272ec6c0a5cf5842f76e0df"
      name      = "${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 3600
      type      = "TXT"
      value     = "MS=ms18158425"
    },
    # Gitlab
    {
      name      = "_gitlab-pages-verification-code.tyg3r.${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "gitlab-pages-verification-code=a2eed2c3d30bcbfabe28c59ee64caf3e"
    },
    {
      name      = "tyg3r-a.${local.domains["xyz"]}"
      proxiable = true
      proxied   = true
      ttl       = 1
      type      = "CNAME"
      value     = "b6043.gitlab.io"
    },
    # Google
    {
      id        = "google_verification"
      name      = "${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "google-site-verification=T0XlDvIcVdtuYPckOlmV9kL1GiIuLiC4TKfGqg_vaLE"
    },
    # Sendgrid
    {
      name = "em456.${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      value     = "u24570643.wl144.sendgrid.net"
    },
    {
      name      = "s1._domainkey.${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      value     = "s1.domainkey.u24570643.wl144.sendgrid.net"
    },
    {
      name      = "s2._domainkey.${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      value     = "s2.domainkey.u24570643.wl144.sendgrid.net"
    },
    # CF Mail
    {
      hostname  = "${local.domains["xyz"]}"
      id        = "cloudflare_spf"
      name      = "${local.domains["xyz"]}"
      proxiable = false
      proxied   = false
      ttl       = 1
      type      = "TXT"
      value     = "v=spf1 include:_spf.mx.cloudflare.net ~all"
    },
    # {
    #   name = "${local.domains["xyz"]}",
    #   type = "MX",
    #   value = "route1.mx.cloudflare.net"
    #   priority = 48
    #   proxied = false
    # },
    #  {
    #   name = "${local.domains["xyz"]}",
    #   type = "MX",
    #   value = "route2.mx.cloudflare.net"
    #   priority = 24
    #   proxied = false
    # },
    #  {
    #   name = "${local.domains["xyz"]}",
    #   type = "MX",
    #   value = "route3.mx.cloudflare.net"
    #   priority = 38
    #   proxied = false
    # }
  ]
  dns_srv_entries = [
    # _service._proto.name. TTL class type of record priority weight port target.
    # _imap._tcp 10800 IN SRV 0 0 0   .
    # _imaps._tcp 10800 IN SRV 0 1 993 mail.gandi.net.
    # _pop3._tcp 10800 IN SRV 0 0 0   .
    # _pop3s._tcp 10800 IN SRV 10 1 995 mail.gandi.net.
    # _submission._tcp 10800 IN SRV 0 1 465 mail.gandi.net.
    {
      type      = "SRV"
      data = {
        service = "_imap"
        proto = "_tcp"
        priority  = 0
        weight = 0
        port   = 0
        name = "imap.${local.domains["xyz"]}"
        target = "."
      }
    },
    {
      ttl       = 1
      type      = "SRV"
      data = {
        service = "_pop3"
        proto = "_tcp"
        priority  = 0
        weight = 0
        port   = 0
        name = "pop3.${local.domains["xyz"]}"
        target = "."
      }
    }
  ]
}

# Importing is not available. I had to delete the upstream resource and let terraform recreate it
resource "cloudflare_web3_hostname" "cf_domain_xyz_web3" {
  zone_id     = module.cf_domain_xyz.zone_id
  description = "IPFS Gateway at BloopNet"
  target      = "ipfs"
  name        = "ipfs.${local.domains["xyz"]}"
  dnslink     = "/ipns/onboarding.ipfs.cloudflare.com"
}


# There is additional verification downstream at network and cluster firewalls, traefik, etc.
resource "cloudflare_ruleset" "xyz_custom_ruleset" {
  zone_id     = module.cf_domain_xyz.zone_id
  name        = "default"
  description = ""
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action = "skip"
    expression = format("(ip.geoip.asnum eq 36459 and http.host eq \"notify.%s\")", local.domains["xyz"])
    description = "Allow GitHub to Flux API"
    enabled = true
    action_parameters {
      ruleset = "current"
            }
    logging {
      enabled = true
    }
  }
  rules {
    action = "block"
        expression = "(ip.geoip.country ne \"US\") or (cf.threat_score ge 5)"
        description= "Restrict NAS access"
        enabled= false
    }
}

resource "cloudflare_page_rule" "cf_domain_xyz_plex_bypass_cache" {
  zone_id  = module.cf_domain_xyz.zone_id
  target   = format("plex.%s/*", module.cf_domain_xyz.zone)
  status   = "active"
  priority = 1

  actions {
    cache_level         = "bypass"
    disable_performance = true
  }
}

resource "cloudflare_email_routing_address" "xyz_0" {
  account_id = local.cloudflare_secrets["cloudflare_account_id"]
  email      = local.cloudflare_secrets["xyz_0_dest_email"]
}

resource "cloudflare_email_routing_catch_all" "xyz_0" {
  zone_id = module.cf_domain_xyz.zone_id
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

resource "cloudflare_email_routing_rule" "main_xyz" {
  zone_id = module.cf_domain_xyz.zone_id
  name    = "Forward to primary inbox"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = "zee@${local.domains["xyz"]}"
  }

  action {
    type  = "forward"
    value = ["${local.cloudflare_secrets["xyz_0_dest_email"]}"]
  }
}

resource "cloudflare_record" "dns_records" {
  for_each = { for dns_entry in var.dns_entries : (dns_entry.id != null ? dns_entry.id : "${dns_entry.name}_${dns_entry.priority}") => dns_entry }

  name    = each.value.name
  zone_id = cloudflare_zone.zone.id
  value   = each.value.value
  priority = each.value.priority
  proxied  = contains(["A", "AAAA", "CNAME"], each.value.type) ? each.value.proxied : false
  type     = each.value.type
  ttl      = each.value.ttl
}

data "cloudflare_record" "ext_dns_records" {
  for_each = { for dns_entry in var.ext_dns_entries : (dns_entry.id != null ? dns_entry.id : "${dns_entry.hostname}_${dns_entry.priority}") => dns_entry }

  hostname = each.value.hostname
  zone_id  = cloudflare_zone.zone.id
  priority = each.value.priority
  type     = each.value.type
}

resource "cloudflare_record" "dns_srv_records" {
  for_each = { for dns_entry in var.dns_srv_entries : (dns_entry.id != null ? dns_entry.id : "${dns_entry.data.service}.${dns_entry.data.proto}_${dns_entry.priority}") => dns_entry }

  name    = "${each.value.data.service}.${each.value.data.service}"
  zone_id = cloudflare_zone.zone.id
  data {
    target = each.value.data.target
    weight = each.value.data.weight
    port = each.value.data.port
    service = each.value.data.service
    proto = each.value.data.proto
    priority = each.value.data.priority
    name = each.value.data.name
  }
  type     = each.value.type
  ttl      = each.value.ttl
}

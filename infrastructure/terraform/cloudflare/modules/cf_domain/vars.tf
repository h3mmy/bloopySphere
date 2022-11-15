variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "domain" {
  type = string
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "enable_default_firewall_rules" {
  type    = bool
  default = true
}

variable "dns_entries" {
  type = list(object({
    id    = optional(string)
    name  = string,
    value = optional(string),
    type      = optional(string, "A"),
    proxiable = optional(bool, true),
    proxied   = optional(bool, true),
    priority  = optional(number, 0),
    ttl       = optional(number, 1)
  }))
  default = []
}


# data {
#     service  = "_sip"
#     proto    = "_tls"
#     name     = "terraform-srv"
#     priority = 0
#     weight   = 0
#     port     = 443
#     target   = "example.com"
#   }

variable "dns_srv_entries" {
  type = list(object({
    id    = optional(string)
    data  = object({
      target = string,
      weight = number,
      port = number,
      priority  = optional(number, 0),
      proto = string
      service = string
      name = optional(string)
    }),
    type      = optional(string, "A"),
    proxiable = optional(bool, true),
    proxied   = optional(bool, true),
    priority  = optional(number, 0),
    ttl       = optional(number, 1)
  }))
  default = []
}

# For data objects
variable "ext_dns_entries" {
  type = list(object({
    id       = optional(string)
    hostname = string,
    zone_id  = string
    value    = optional(string),
    type     = optional(string, "A"),
    priority = optional(number, 0)
  }))
  default = []
}

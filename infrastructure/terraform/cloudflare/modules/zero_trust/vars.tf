variable "account_id" {
  type      = string
  sensitive = true
}

variable "tunnel_secret" {
    type = string
    sensitive = true
}

variable "api_ipv4" {
    type = string
    # e.g. "198.51.100.101/32"
    description = "Kubernetes API Server (IPv4)"
}


# variable "api_ipv6" {
#     type = string
#     # e.g "2001:DB8::101/128"
#     description = "Kubernetes API Server (IPv6)"
# }

variable "account_id" {
  type      = string
  sensitive = true
}

variable "tunnel_secret" {
  type      = string
  sensitive = true
}

variable "az_directory_id" {
  type        = string
  sensitive   = true
  description = "Azure Directory (tenent) ID"
}

variable "az_application_id" {
  type        = string
  description = "Azure Application ID"
}

variable "az_application_secret" {
  type        = string
  sensitive   = true
  description = "Azure Application Secret"
}

variable "api_ipv4" {
  type = string
  # e.g. "198.51.100.101/32"
  description = "Kubernetes API Server (IPv4)"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "api_cname" {
  type        = string
  description = "subdomain where you want to access the k8s api tunnel"
}

variable "api_domain_name" {
  type        = string
  description = "base domain where you want to access the k8s api tunnel"
}

# variable "api_ipv6" {
#     type = string
#     # e.g "2001:DB8::101/128"
#     description = "Kubernetes API Server (IPv6)"
# }

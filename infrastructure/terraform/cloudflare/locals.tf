locals {
  cloudflare_secrets = sensitive(yamldecode(nonsensitive(data.sops_file.cloudflare_secrets.raw)))
  domains            = yamldecode(nonsensitive(data.sops_external.domains.raw))
  status_dev_ipv4    = "192.0.2.1"
  status_dev_ipv6    = "100::"
  gitlab_repo = "h3mmy.gitlab.io"
}

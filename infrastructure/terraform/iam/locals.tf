locals {
  iam_secrets = sensitive(yamldecode(nonsensitive(data.sops_file.iam_secrets.raw)))
  domains     = yamldecode(nonsensitive(data.sops_external.domains.raw))
  realm_name = "bloopnet"
}

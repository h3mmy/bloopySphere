locals {
  oci_secrets = sensitive(yamldecode(nonsensitive(data.sops_file.oci_secrets.raw)))
  home_region          = "us-ashburn-1"
  region               = "us-ashburn-1"
  label_prefix         = "quarky"
  vcn_dns_label        = "quarkynet"
  vcn_name             = "quarkynet"
}

locals {
  gcp_secrets = sensitive(yamldecode(nonsensitive(data.sops_file.gcp_secrets.raw)))
  key_ring_name = "bloopy-vault"
  crypto_key_name = "bloopy-vault-crypt"
}

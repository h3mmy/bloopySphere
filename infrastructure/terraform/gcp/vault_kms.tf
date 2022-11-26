module "bloopysphere_vault_kms" {
  source         = "./modules/gcp_kms"
  gcloud-project = local.gcp_secrets["gcp_project_name"]
  gcloud-region  = local.gcp_secrets["gcp_region"]
  key_ring_name = local.key_ring_name
  crypto_key = local.crypto_key_name
}

provider "google" {
  credentials = local.gcp_secrets["serviceaccount.json"]
  project     = local.gcp_secrets["gcp_project_name"]
  region      = local.gcp_secrets["gcp_region"]
}

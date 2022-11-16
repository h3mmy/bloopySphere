provider "oci" {
  region       = local.home_region
#   fingerprint  = var.api_fingerprint
  private_key  = local.oci_secrets["api_private_key"]
  tenancy_ocid = local.oci_secrets["tenancy_ocid"]
  user_ocid    = local.oci_secrets["user_ocid"]
  alias        = "home"
}

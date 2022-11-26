data "sops_file" "gcp_secrets" {
  source_file = "secrets.sops.yaml"
}

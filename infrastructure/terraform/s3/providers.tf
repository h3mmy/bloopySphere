provider "minio" {
  alias          = "bloop"
  minio_server   = "s3.${data.sops_file.domains.data["xyz"]}"
  minio_user     = data.sops_file.s3_secrets.data["minio_access_key"]
  minio_password = data.sops_file.s3_secrets.data["minio_secret_key"]
  minio_ssl      = true
}

module "minio_bucket_volsync" {
  source      = "./modules/minio_bucket"
  bucket_name = "volsync"
  user_name = "volsync-tf"
  user_secret = data.sops_file.s3_secrets.data["volsync_minio_password"]
  providers = {
    minio = minio.bloop
  }
}

output "volsync_access_key" {
  value = module.minio_bucket_volsync.minio_access_key
}

output "volsync_secret_key" {
  value = module.minio_bucket_volsync.minio_secret_key
  sensitive = true
}

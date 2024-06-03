module "minio_bucket_thanos" {
  source      = "./modules/minio_bucket"
  bucket_name = "thanos"
  user_name = "thanos-tf"
  providers = {
    minio = minio.bloop
  }
}

module "minio_bucket_velero_v2" {
  source      = "./modules/minio_bucket"
  bucket_name = "velero-2"
  user_name = "velero-tf"
  user_secret = data.sops_file.s3_secrets.data["velero_minio_password"]
  providers = {
    minio = minio.bloop
  }
}

# Temporary output forwarding until secret transport is ready (TODO: make issue)

output "velero_access_key" {
  value = module.minio_bucket_velero_v2.minio_access_key
}

output "velero_secret_key" {
  value = module.minio_bucket_velero_v2.minio_secret_key
  sensitive = true
}

output "thanos_access_key" {
  value = module.minio_bucket_thanos.minio_access_key
}

output "thanos_secret_key" {
  value = module.minio_bucket_thanos.minio_secret_key
  sensitive = true
}

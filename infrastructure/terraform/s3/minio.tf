# module "minio_bucket_thanos" {
#   source      = "./minio_bucket"
#   bucket_name = "thanos"
#   providers = {
#     minio = minio.bloop
#   }
# }

# module "minio_bucket_loki" {
#   source      = "./minio_bucket"
#   bucket_name = "loki"
#   providers = {
#     minio = minio.bloop
#   }
# }

module "minio_bucket_velero_v2" {
  source      = "./modules/minio_bucket"
  bucket_name = "velero-2"
  user_name = "velero-tf"
  user_secret = data.sops_file.s3_secrets.data["velero_minio_password"]
  providers = {
    minio = minio.bloop
  }
}

# Temporary output forwarding until secret transport is ready

output "velero_access_key" {
  value = module.minio_bucket_velero_v2.minio_access_key
}

output "velero_secret_key" {
  value = module.minio_bucket_velero_v2.minio_secret_key
  sensitive = true
}

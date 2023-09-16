terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.4"
    }
    minio = {
      source  = "aminueza/minio"
      version = "1.18.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

data "sops_file" "s3_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_file" "domains" {
  source_file = "domains.sops.yaml"
}

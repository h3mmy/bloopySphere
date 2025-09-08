terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.10.0"
    }
    minio = {
      source  = "aminueza/minio"
      version = "3.5.4"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
}

data "sops_file" "s3_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_file" "domains" {
  source_file = "domains.sops.yaml"
}

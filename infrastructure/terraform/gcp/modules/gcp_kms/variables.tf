variable "vault_url" {
  default = "https://releases.hashicorp.com/vault/1.12.1/vault_1.12.1_linux_amd64.zip"
}

variable "gcloud-project" {
  description = "Google project name"
}

variable "gcloud-region" {
  default = "us-east1"
}

variable "vault_service_account_id" {
  default = "vault-gcpkms"
}

variable "vault_service_account_display_name" {
  default = "Vault KMS for auto-unseal"
}

variable "key_ring_name" {
  description = "Cloud KMS key ring name to create"
  default     = "test"
}

variable "crypto_key" {
  default     = "vault-test"
  description = "Crypto key name to create under the key ring"
}

variable "keyring_location" {
  default = "global"
}

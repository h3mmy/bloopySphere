terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.55.0"
    }
  }
}

# Create serviceaccount for vault kms
resource "google_service_account" "vault_kms_service_account" {
  account_id   = var.vault_service_account_id
  display_name = var.vault_service_account_display_name
}

# Create a KMS key ring
resource "google_kms_key_ring" "key_ring" {
  project  = var.gcloud-project
  name     = var.key_ring_name
  location = var.keyring_location
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "crypto_key" {
  name            = var.crypto_key
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "100000s"
}

# Add the service account to the Keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  # key_ring_id = "${google_kms_key_ring.key_ring.id}"
  key_ring_id = "${var.gcloud-project}/${var.keyring_location}/${var.key_ring_name}"
  role        = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault_kms_service_account.email}",
  ]
}

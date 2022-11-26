# Modules

Modules part of the gcp provider

## GCP KMS

Purpose of this module is to set up a KMS keyring for the purposes of using it with hashicorp vault

Requires Service Account with

- GCP Project Name
- `Cloud KMS Admin` (To create the keyring and key)
- `Service Account Admin`(To create the service account for use with vault and bind it to the appropriate IAM)

# Hashicorp Vault

Added for [#2488](https://github.com/h3mmy/bloopySphere/issues/2488)

## Vault Secret Operator

Adjunct Operator: [vault-secret-operator](https://github.com/ricoberger/vault-secrets-operator)

## Pre-reqs

If you already have a keyring:

- Service account with IAM Role `Cloud KMS CryptoKey Encrypter/Decrypter`

Else:

- Service account with IAM Role `Cloud KMS Admin`
- Terraform module to create keyring

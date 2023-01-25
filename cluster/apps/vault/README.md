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

## Initialization

### Vault

[github - vault-helm](https://github.com/hashicorp/vault-helm)

Some quirks I noted with the helm values:

- `ingress` is nested under `server`
- `pathType` is set at Ingress level

Requires the following steps.

```bash
vault status          # running, should be recovery seal type: gcpckms, sealed: true)
vault operator init   # initialises with 5 key shares and a key treshold of 3. distribute carefully.
vault status          # should be recovery seal type: shamir, sealed: false
```

The `vault operator init` command will generate important keys we want to use elsewhere including in the vault helm release itself. This makes it tricky to not require manual steps. I've attempted to use parts of billimek's bootstrapping script in the init-vault job in ./jobs

### Vault Secrets Operator

This is whaat is typically recommended for initializing the vault-secrets operator including [official documentation](https://github.com/ricoberger/vault-secrets-operator). It should be noted that as of kubernetes v1.24 (See [v1.24 urgent notes](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.24.md#urgent-upgrade-notes)) [service account secrets](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets) will no longer be automatically generated.

```sh
export VAULT_ADDR=<if port-forward http://localhost:8200 else $vault_addr>
export VAULT_SECRETS_OPERATOR_NAMESPACE=<your namespace>
export VAULT_SECRET_NAME=$(kubectl get sa -n $VAULT_SECRETS_OPERATOR_NAMESPACE vault-secrets-operator -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret -n $VAULT_SECRETS_OPERATOR_NAMESPACE $VAULT_SECRET_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret -n $VAULT_SECRETS_OPERATOR_NAMESPACE $VAULT_SECRET_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_HOST=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
env | grep -E 'VAULT_SECRETS_OPERATOR_NAMESPACE|VAULT_SECRET_NAME|SA_JWT_TOKEN|SA_CA_CRT|K8S_HOST'

vault write auth/kubernetes/config \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_host="$K8S_HOST" \
    kubernetes_ca_cert="$SA_CA_CRT" \
    issuer="https://kubernetes.default.svc.cluster.local" \
    disable_iss_validation=false

vault write auth/kubernetes/role/vault-secrets-operator \
  bound_service_account_names="vault-secrets-operator" \
  bound_service_account_namespaces="$VAULT_SECRETS_OPERATOR_NAMESPACE" \
  policies=vault-secrets-operator \
  ttl=24h
```

Instead, we will use the local sa token as per [vault documentation](https://developer.hashicorp.com/vault/docs/auth/kubernetes#use-local-service-account-token-as-the-reviewer-jwt). This also simplifies the "manual" steps required.
TODO: update init-vault job to use this method of setup for vault-secrets-operator

```bash
export VAULT_SECRETS_OPERATOR_NAMESPACE=$(kubectl -n $VAULT_NAMESPACE get sa vault-secrets-operator -o jsonpath="{.metadata.namespace}")
export K8S_HOST=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export K8S_ISSUER=$(kubectl get --raw /.well-known/openid-configuration | jq -r .issuer)

vault write auth/kubernetes/config \
    kubernetes_host=$K8S_HOST \
    issuer=$K8S_ISSUER

vault write auth/kubernetes/role/vault-secrets-operator \
  bound_service_account_names="vault-secrets-operator" \
  bound_service_account_namespaces="$VAULT_SECRETS_OPERATOR_NAMESPACE" \
  policies=vault-secrets-operator \
  ttl=24h
```

## Enable OIDC

Using [documentation](https://developer.hashicorp.com/vault/tutorials/auth-methods/oidc-auth)
TODO: Move this process into a tf config?

### Make policy/policies

```sh
vault policy write manager - <<EOF
# Manage k/v secrets
path "/secret/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
```

```sh
vault policy write reader -<<EOF
# Read permission on the k/v secrets
path "/secret/*" {
    capabilities = ["read", "list"]
}
EOF
```

### Enable OIDC AUTH method

`vault auth enable oidc`

Write Config

```sh
vault write auth/oidc/config \
         oidc_discovery_url="https://${DISCOVERY_URL}" \
         oidc_client_id="${CLIENT_ID}" \
         oidc_client_secret="${CLIENT_SECRET}" \
         default_role="reader"
```

Create Reader Role

```sh
vault write auth/oidc/role/reader \
      bound_audiences="${CLIENT_ID}" \
      allowed_redirect_uris="https://vault.${XYZ_DOMAIN}/ui/vault/auth/oidc/oidc/callback" \
      allowed_redirect_uris="https://vault.${XYZ_DOMAIN}/oidc/callback" \
      allowed_redirect_uris="http://localhost:8250/oidc/callback" \
      user_claim="sub" \
      oidc_scopes="openid,profile" \
      policies="reader"
```

Create Manager Role

```sh
vault write auth/oidc/role/kv-mgr \
         bound_audiences="${CLIENT_ID}" \
         allowed_redirect_uris="https://vault.${XYZ_DOMAIN}/ui/vault/auth/oidc/oidc/callback" \
         allowed_redirect_uris="https://vault.${XYZ_DOMAIN}/oidc/callback" \
         allowed_redirect_uris="http://localhost:8200/ui/vault/auth/oidc/oidc/callback" \
         allowed_redirect_uris="http://localhost:8250/oidc/callback" \
         user_claim="sub" \
         token_policies="reader" \
         oidc_scopes="openid,profile" \
         groups_claim="groups"
```

Create Group-Policy link

```sh
vault write identity/group name="manager" type="external" \
         policies="manager" \
         metadata=responsibility="Manage K/V Secrets"
```

Create OIDC Mapping

```sh
GROUP_ID=$(vault read -field=id identity/group/name/manager)
OIDC_AUTH_ACCESSOR=$(vault auth list -format=json  | jq -r '."oidc/".accessor')

vault write identity/group-alias name="kv-mgr" \
         mount_accessor="$OIDC_AUTH_ACCESSOR" \
         canonical_id="$GROUP_ID"
```

To login via oidc `vault login -method=oidc role="kv-mgr"`

provider "keycloak" {
    client_id     = local.iam_secrets["kc_client_id"]
    client_secret = local.iam_secrets["kc_client_secret"]
    url           = "https://iam.${local.domains["xyz"]}"
    realm = local.realm_name
}

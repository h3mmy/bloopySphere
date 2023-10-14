data "sops_file" "iam_secrets" {
  source_file = "secrets.sops.yaml"
}

data "sops_external" "domains" {
  source     = data.http.bloopysphere_domains.response_body
  input_type = "yaml"
}

data "http" "bloopysphere_domains" {
  url = "https://raw.githubusercontent.com/h3mmy/bloopysphere/main/infrastructure/shared/domains.sops.yaml"
}

module "bloopy_iam" {
  source     = "./modules/keycloak"
  realm_name = local.realm_name
  smtp_username  = local.iam_secrets["kc_smtp_server_username"]
  smtp_password = local.iam_secrets["kc_smtp_server_password"]
  smtp_host = "smtp.sendgrid.net"
  domain = local.domains["xyz"]
  user_groups = [
    {
        name= "base-user"
    },
    {
        name= "blogs-admin"
    },
    {
        name = "bloopnet-admin"
        realm_roles = ["bloopnet-admin","grafana-admin","grafana-editor"]
    },
    {
      name = "books"
      realm_roles = ["bookworm"]
    },
    {
      name      = "books-rw"
      parent_group = "books",
      realm_roles = ["librarian"]
    },
    {
        name="camelus",
        realm_roles = ["camelus-user"]
    },
    {
        name="electrofuzz"
    },
    {
        name="grafana"
        realm_roles=["grafana-viewer"]
    },
    {
        name="grafana-editor"
        parent_group="grafana"
        realm_roles=["grafana-editor"]
    },
    {
        name="grafana-admin"
        parent_group="grafana"
        realm_roles=["grafana-admin"]
    },
    {
        name = "lldap_admin"
    },
    {
        name = "lldap_password_manager"
    },
    {
        name="lldap_strict_readonly"
    },
    {
        name = "minio"
    },
    {
        name = "minio-admin"
        parent_group = "minio"
        attributes = {
          minio-policy = ["consoleAdmin"]
        }
    },
    {
        name = "minio-loki"
        parent_group = "minio"
    },
    {
        name = "minio-thanos"
        parent_group = "minio"
    },
    {
        name = "mqtt"
        realm_roles = ["mqtt"]
    },
    {
        name = "plex"
        realm_roles = ["base-plex"]
        attributes = {
          music = ["true"]
          tv = ["true"]
          movies = ["true"]
        }
    },
    {
        name = "service_account"
    }
  ]
}

terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
    }
  }
}

resource "keycloak_realm" "bloopnet" {
  realm                                    = var.realm_name
  enabled                                  = true
  access_code_lifespan                     = "1m0s"
  access_code_lifespan_login               = "30m0s"
  access_code_lifespan_user_action         = "5m0s"
  access_token_lifespan                    = "5m0s"
  access_token_lifespan_for_implicit_flow  = "15m0s"
  action_token_generated_by_admin_lifespan = "12h0m0s"
  action_token_generated_by_user_lifespan  = "5m0s"
  direct_grant_flow                        = "direct grant"
  docker_authentication_flow               = "docker auth"
  duplicate_emails_allowed                 = false
  edit_username_allowed                    = false
  login_with_email_allowed                 = true
  oauth2_device_code_lifespan              = "10m0s"
  oauth2_device_polling_interval           = 5
  offline_session_max_lifespan_enabled     = false
  refresh_token_max_reuse                  = 0
  remember_me                              = true
  reset_password_allowed                   = true
  revoke_refresh_token                     = false
  ssl_required                             = "external"
  user_managed_access                      = false
  verify_email                             = true
  admin_theme = "keycloak.v2"
  display_name                             = "Bloopnet"
  display_name_html                             = "Bloopnet"

  otp_policy {
    algorithm         = "HmacSHA1"
    digits            = 6
    initial_counter   = 0
    look_ahead_window = 1
    period            = 30
    type              = "totp"
  }

  web_authn_passwordless_policy {
    relying_party_entity_name = "iam-${var.realm_name}"
  }

  web_authn_policy {
    relying_party_entity_name = "iam-${var.realm_name}"
  }

  smtp_server {
          from                  = "bloopyboi@${var.domain}"
          from_display_name     = "BloopyBoi"
          host                  = var.smtp_host
          port                  = "587"
          reply_to              = "bloopyboi@${var.domain}"
          reply_to_display_name = "BloopyBoi"
          ssl                   = false
          starttls              = true

          auth {
              password = var.smtp_password
              username = var.smtp_username
            }
  }
}

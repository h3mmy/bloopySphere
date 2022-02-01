provider "authentik" {
  url   = "https://auth.${XYZ_DOMAIN}"
  token = "foo-bar"
  # Optionally set insecure to ignore TLS Certificates
  # insecure = true
}

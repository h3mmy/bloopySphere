resource "cloudflare_account" "zee" {
  name              = "Zee's Account"
  type              = "standard"
  enforce_twofactor = false
}

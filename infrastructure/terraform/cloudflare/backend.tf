terraform {
  cloud {
    organization = "bloopysphere"
    workspaces {
      name = "home-cloudflare-provisioner"
    }
  }
}

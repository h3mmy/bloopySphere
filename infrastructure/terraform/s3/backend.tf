terraform {
  cloud {
    organization = "bloopysphere"
    workspaces {
      name = "home-s3-provisioner"
    }
  }
}

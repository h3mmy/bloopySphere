terraform {
  cloud {
    organization = "bloopysphere"
    workspaces {
      name = "bloopy-iam-provisioner"
    }
  }
}

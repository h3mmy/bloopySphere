terraform {
  cloud {
    organization = "bloopysphere"
    workspaces {
      name = "bloopy-gcp-provisioner"
    }
  }
}

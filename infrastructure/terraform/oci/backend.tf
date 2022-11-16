terraform {
  cloud {
    organization = "bloopysphere"
    workspaces {
      name = "oracle-cloud-provisioner"
    }
  }
}

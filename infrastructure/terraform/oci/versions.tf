terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "6.8.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

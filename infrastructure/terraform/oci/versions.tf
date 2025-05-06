terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "7.0.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

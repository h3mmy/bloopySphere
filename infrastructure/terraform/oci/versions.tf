terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "5.2.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

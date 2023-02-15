terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "4.108.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

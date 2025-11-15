terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "7.26.1"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}

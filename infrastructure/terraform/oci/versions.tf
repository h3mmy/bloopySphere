terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "6.21.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

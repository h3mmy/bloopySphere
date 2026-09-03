terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      configuration_aliases = [ oci.home ]
      version = "9.0.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
}

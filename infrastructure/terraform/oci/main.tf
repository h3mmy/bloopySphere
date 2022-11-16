data "sops_file" "oci_secrets" {
    source_file = "secrets.sops.yaml"
}

data "oci_core_images" "bastion" {
  compartment_id           = oci_identity_compartment.oke.id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

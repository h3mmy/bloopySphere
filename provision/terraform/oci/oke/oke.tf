resource "oci_identity_compartment" "oke" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for Terraform resources."
  name           = var.compartment_name
  enable_delete  = true
}

data "oci_core_images" "bastion" {
  compartment_id           = oci_identity_compartment.oke.id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

module "oke" {
  source = "oracle-terraform-modules/oke/oci"

  compartment_id = oci_identity_compartment.oke.id

  region              = var.region
  home_region         = var.region
  tenancy_id          = var.tenancy_ocid
  ssh_public_key_path = var.ssh_public_key_path
  create_operator     = false
  bastion_shape = {
    shape = "VM.Standard.E2.1.Micro",
  }
  bastion_image_id            = data.oci_core_images.bastion.images.0.id
  allow_worker_ssh_access     = true
  control_plane_allowed_cidrs = ["0.0.0.0/0"]
  kubernetes_version          = "v1.22.5"
  subnets = {
    bastion  = { netnum = 0, newbits = 13 }
    operator = { netnum = 1, newbits = 13 }
    cp       = { netnum = 2, newbits = 13 }
    int_lb   = { netnum = 16, newbits = 11 }
    pub_lb   = { netnum = 17, newbits = 11 }
    workers  = { netnum = 1, newbits = 2 }
    fss      = { netnum = 18, newbits = 11 }
  }
  node_pools = {
    np1 = {
      boot_volume_size = 50
      node_pool_size   = 2
      ocpus            = 2
      shape            = "VM.Standard.A1.Flex"
      memory           = 12
    }
  }
  providers = {
    oci.home = oci
  }
}

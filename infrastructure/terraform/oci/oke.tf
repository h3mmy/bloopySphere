resource "oci_identity_compartment" "oke" {
  compartment_id = local.oci_secrets["compartment_ocid"]
  description    = "Compartment for Terraform resources."
  name           = local.oci_secrets["compartment_name"]
  enable_delete  = true
}

module "oke" {
  # External module. See https://registry.terraform.io/modules/oracle-terraform-modules/oke/oci
  source = "oracle-terraform-modules/oke/oci"

  compartment_id = oci_identity_compartment.oke.id

  region          = local.region
  home_region     = local.region
  tenancy_id      = local.oci_secrets["tenancy_ocid"]
  ssh_public_key  = local.oci_secrets["ssh_public_key"]
  create_operator = false
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
    pods     = { netnum = 2, newbits = 2 }
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

# Obtain provisioned Kubeconfig.
data "oci_containerengine_cluster_kube_config" "kube_config" {
  cluster_id = module.oke.cluster_id
}

# Store kubeconfig in vault.
# resource "vault_generic_secret" "kube_config" {
#   path = "my/cluster/path/kubeconfig"
#   data_json = jsonencode({
#     "data" : data.oci_containerengine_cluster_kube_config.kube_config.content
#   })
# }

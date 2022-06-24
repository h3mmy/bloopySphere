variable "ssh_public_key_path" {
  description = "The filesystem path of an SSH public key to authorised for host authentication"
  default     = "~/.ssh/id_rsa.pub"
}

variable "region" {
  description = "The OCI region we're using"
  default     = "us-ashburn-1"
}

variable "tenancy_ocid" {
  description = "The OCID of the parent tenancy in which we're creating a compartment"
}

variable "compartment_name" {
  default = "kubernetes"
}

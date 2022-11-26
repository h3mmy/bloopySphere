# GCP Provider

Uses [google/google](https://registry.terraform.io/providers/hashicorp/google)

Uses the gcp_kms module to generate a keyring and service account for use with vault.

The service account for vault can be injected as a secret into the cluster using the [hashicorp/kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes) provider. In this scenario, you would need to add the service account as an output so it can be used in that module.

I plan on just using the cloud console (for now) to save me some time and to ensure this module works properly.

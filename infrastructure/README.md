# Infrastructure

Mainly terraform modules. I am using a remote backend in [Terraform Cloud](https://developer.hashicorp.com/terraform/language/settings/terraform-cloud) in lieu of a local tfstate. This way I can automate terraform changes. You can use other backends including an s3 bucket, which I may do at some point after getting the pipes set up.

## SOPS

These runners will sometimes run via terraform cloud. As such, I have added a sops key per workspace as tfe runner variables in my configuration. Since this step isn't immediately evident by the files, I wanted to make a note. See my `.sops.config.yaml`.

Note: The relevant private key needs to be in an environment variable named SOPS_AGE_KEY. Alternatively you could pay 1-3 USD per month per key using a managed key service.

Also, don't forget to re-encrypt your sops file after adding new keys to it.

Snippets:
`age-keygen -o tf-mymodule.agekey`
`cat tf-mymodule.agekey >> $SOPS_AGE_KEY_FILE`

Add privkey to SOPS_AGE_KEY in tf runner.

## Cloudflare

For maintaining domains that interface with the bloopysphere. Attempted to use [terraformer](https://github.com/GoogleCloudPlatform/terraformer) and [cf-terraforming](https://github.com/cloudflare/cf-terraforming) in an effort to make the migration easier, but they were uncooperative. Eventually I managed to get a rudimentary state via terraformer and did a manual walk through to copy the resource definitions. It can be scripted but I didn't have enough entries to justify that. A few "Find & Replace" ops later and I had the resource files you can see in the folder.

The base structure was inspired by [bjw-s/home-ops](https://github.com/bjw-s/home-ops), but I've made adjustments. I ran a manual terraform import for the resources (easy bash script). Then I added required modifications for some resources, for example, changes required for SRV records. A few resources got caught unecessarily such as cloudflare MX records that are managed by the cloudflare_email_routing set of resources. These were simply ejected via `terraform state rm <identifier>`.

Note regarding ddns: I have forgone the IPv4 detection via http check. The terraform runner will not always be local to my network as it may sometimes run in terraform cloud or a github runner, etc. For now it is going to be populated via a sops file. The DDNS cron-job will need to be adjusted to update the state via this channel to avoid conflict.

After getting this set up, I added the sops age key to the terraform cloud config and connected it to this repository. It will auto-apply changes when branch `main` has changes at `infrastructure/terraform/cloudflare` or `infrastructure/shared`. Once I have the other facets set up, I will be shifting this to API usage via either a github runner, or declarative webhook via github, or via flux. Idk yet.

## Oracle Cloud

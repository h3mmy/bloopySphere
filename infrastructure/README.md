# Infrastructure

Mainly terraform modules. I am using a remote backend in [Terraform Cloud](https://developer.hashicorp.com/terraform/language/settings/terraform-cloud) in lieu of a local tfstate. This way I can automate terraform changes. You can use other backends including an s3 bucket, which I may do at some point after getting the pipes set up.

## Cloudflare

For maintaining domains that interface with the bloopysphere. Attempted to use [terraformer](https://github.com/GoogleCloudPlatform/terraformer) and [cf-terraforming](https://github.com/cloudflare/cf-terraforming) in an effort to make the migration easier, but they were uncooperative. Eventually I managed to get a rudimentary state via terraformer and did a manual walk through to copy the resource definitions. It can be scripted but I didn't have enough entries to justify that. A few "Find & Replace" ops later and I had the resource files you can see in the folder.

The base structure was inspired by [bjw-s/home-ops](https://github.com/bjw-s/home-ops), but I've made adjustments. I ran a manual terraform import for the resources (easy bash script). Then I added required modifications for some resources, for example, changes required for SRV records. A few resources got caught unecessarily such as cloudflare MX records that are managed by the cloudflare_email_routing set of resources. These were simply ejected via `terraform state rm <identifier>`.

Note regarding ddns: I have forgone the IPv4 detection via http check. The terraform runner will not always be local to my network as it may sometimes run in terraform cloud or a github runner, etc. For now it is going to be populated via a sops file. The DDNS cron-job will need to be adjusted to update the state via this channel to avoid conflict.

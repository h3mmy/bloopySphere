# Authentik

`sp-authentik.yaml` was generated using the linkerd CLI

The openApi spec is from `auth.${MY_DOMAIN}/api/v3/schema`

`linkerd profile -n auth --open-api /path/to/authentik.yaml authentik > ./cluster/apps/auth/authentik/sp-authentik.yaml`

I would much prefer to be able to generate these dynamically but linkerd doesn't provide a straightforward way to do this.

Because authentik is quite inconvenient for gitops, the outposts folder doesn't work and is excluded. I've left it up for posterity.

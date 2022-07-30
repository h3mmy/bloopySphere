# Helm Release

I've switched away from using the emqx operator due to it not correctly mutating the CRD from v1beta2 to v1beta3. I didn't have the patience to dive in and fix it. I've been busy.

## Notes

* Ingresses are defined in [cluster/apps/networking/traefik/routers/home-emqx.yaml](https://github.com/h3mmy/bloopysphere/blob/main/cluster/apps/networking/traefik/routers/home-emqx.yaml)

---
For posterity here are notes from when I was using the operator for people who want a reference. I'll leave the CRD here but disabled. I've removed the operator yamls.

## EMQX Broker

Depends on `/cluster/core/emqx-operator` as management of CRDS is delegated to it. See [emqx/emqx-operator](https://github.com/emqx/emqx-operator).

Reference for the EmqxBroker can be found [here](https://github.com/emqx/emqx-operator/tree/main/docs/en_US/reference)

### Configuration

[Reference](https://www.emqx.io/docs/en/v4.4/configuration/configuration.html)

By default, EMQX maps environment variables with prefix `EMQX_` to key-value pairs in configuration files.

Mapping rules from environment variable name to config key

* Prefix `EMQX_` is removed
* Upper case letters are mapped to lower case letters
* Double underscore `__` is mapped to `.`

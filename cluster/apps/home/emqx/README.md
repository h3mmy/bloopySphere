# EMQX Broker

Depends on `/cluster/core/emqx-operator` as management of CRDS is delegated to it. See [emqx/emqx-operator](https://github.com/emqx/emqx-operator).

Reference for the EmqxBroker can be found [here](https://github.com/emqx/emqx-operator/tree/main/docs/en_US/reference)

## Configuration

[Reference](https://www.emqx.io/docs/en/v4.4/configuration/configuration.html)

By default, EMQX maps environment variables with prefix `EMQX_` to key-value pairs in configuration files.

Mapping rules from environment variable name to config key

* Prefix `EMQX_` is removed
* Upper case letters are mapped to lower case letters
* Double underscore `__` is mapped to `.`

# SNMP Exporter

This is using the [prometheus snmp-exporter](https://github.com/prometheus/snmp_exporter)

The exporter has a default config file [snmp.yml](https://raw.githubusercontent.com/prometheus/snmp_exporter/v0.21.0/snmp.yml/). It is too big to fit in a configMap.
If needed a generator is available [here](https://github.com/prometheus/snmp_exporter/tree/main/generator)

If you want to use auth credentials from a secret you can use a secret, mount it using `extraSecretMounts` in the helm-values and pass an extraArg `"--web.config.file=/config/basic_auth.yaml"`
The basic_auth.yaml looks like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: secret-name
    namespace: monitoring
stringData:
    basic_auth.yaml: |
      basic_auth_users:
        alice: $2y$10$X0h1gDsPszWURQaxFh.zoubFi6DXncSjhoQNJgRrnGs7EsimhC7zG

```

To hash is in bcrypt which you can generate using `htpasswd -nBC 10 "" | tr -d ':\n'`

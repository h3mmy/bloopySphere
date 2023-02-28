# SNMP Exporter

This is using the [prometheus snmp-exporter](https://github.com/prometheus/snmp_exporter)

The exporter has a default config file which works for my purposes [snmp.yml](https://\
47aw.githubusercontent.com/prometheus/snmp_exporter/v0.21.0/snmp.yml/). Instead of using a simple kustomization to download it, I've made a copy so it doesn't have a fit when my internet is down.
If needed a generator is available [here](https://github.com/prometheus/snmp_exporter/tree/main/generator)

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

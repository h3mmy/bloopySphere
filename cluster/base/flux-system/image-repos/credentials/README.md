# Generating .dockerconfigjson

1. Generate PAT on platform
2. Encode to base64 (we'll call this `<auth>`)
`echo -n <username>:<token> | base64`
3. Construct .dockerconfigjson Secret
4. Encrypt with SOPS
`sops -i -e /path/to/<secret_name>.sops.yaml`

```yaml
---
apiVersion: v1
kind: Secret
metadata:
    name: <secret_name>
    namespace: flux-system
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"<registry_url>":{"auth":"<auth>"}}}'
```

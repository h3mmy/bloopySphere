# cert-manager namespace

[cert-manager](https://github.com/jetstack/cert-manager) for natively automatically obtaining and renewing LetsEncrypt certificates

* [operator](controller/app/helm-release.yaml)
* [trust-manager](trust-manager/app/helm-release.yaml)
* [csi-driver-spiffe](csi-driver-spiffe/app/helm-release.yaml)

dependency tree:

```ascii
operator -> prom-rules                  -\
         -> cert-issuers                --> csi-driver-spiffe
         -> trust-manager -> ca-bundles -/
```

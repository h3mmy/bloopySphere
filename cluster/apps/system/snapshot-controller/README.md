# Snapshot Controller

~~DISCLAIMER: This directory is NOT in active use. See [cluster/core/rook-ceph/snapshot-controller] for current implementation~~

The GA in-tree contoller(s) are documented [kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter/)

This directory is using a specific flavor [piraeusdatastore snapshot-controller](https://github.com/piraeusdatastore/helm-charts/tree/main/charts/snapshot-controller). This is for convenience. The piraeus snapshot controller chart includes the validating webhook.

Other options to consider is a simple scheduler such as [fairwinds/gemini](https://github.com/FairwindsOps/gemini)

## Certificates

The ca bundle and related issuer/cert/etc are declared in [cluster/core/cert-manager/certs]

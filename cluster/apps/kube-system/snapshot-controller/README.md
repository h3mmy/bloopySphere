# Snapshot Controller

DISCLAIMER: This directory is NOT in active use. See [cluster/core/rook-ceph/snapshot-controller] for current implementation

The GA in-tree contoller(s) are documented [kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter/tree/main#usage)

This directory is using a specific flavor [piraeusdatastore snapshot-controller](https://github.com/piraeusdatastore/helm-charts/tree/main/charts/snapshot-controller). This is for convenience and not necessary since I do not use linstor or zfs currently.

Other options to consider is a simple scheduler such as [fairwinds/gemini](https://github.com/FairwindsOps/gemini)

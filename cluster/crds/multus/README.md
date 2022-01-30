# kube-system

## Multus

[Multus](https://github.com/k8snetworkplumbingwg/multus-cni) allows adding
multiple NICs to a pod. This is needed by home-assistant and other PODs
using protocols that do not pass a router, such a discovery for Google
home.

* [Multus](helm-release.yaml)

**NOTE**: this only installs the CRD.
**NOTE**: Currently Disabled

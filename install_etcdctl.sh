#!/usr/bin/env bash

# Check Version
curl -L --cacert /var/lib/rancher/k3s/server/tls/etcd/server-ca.crt --cert /var/lib/rancher/k3s/server/tls/etcd/server-client.crt --key /var/lib/rancher/k3s/server/tls/etcd/server-client.key https://127.0.0.1:2379/version

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

etcd_version=v3.5.3

case "$(uname -m)" in
    aarch64) arch="arm64" ;;
    x86_64) arch="amd64" ;;
esac;

etcd_name="etcd-${etcd_version}-linux-${arch}"

curl -sSfL "https://github.com/etcd-io/etcd/releases/download/${etcd_version}/${etcd_name}.tar.gz" \
    | tar xzvf - -C /usr/local/bin --strip-components=1 "${etcd_name}/etcdctl"


# K3s specific

export ETCDCTL_ENDPOINTS='https://127.0.0.1:2379'
export ETCDCTL_CACERT='/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt'
export ETCDCTL_CERT='/var/lib/rancher/k3s/server/tls/etcd/server-client.crt'
export ETCDCTL_KEY='/var/lib/rancher/k3s/server/tls/etcd/server-client.key'
export ETCDCTL_API=3

#!/bin/bash
KIND=CustomResourceDefinition
RELEASE=cert-manager
NAMESPACE=cert-manager

# for CRD in objectbuckets.objectbucket.io volumes.rook.io objectbucketclaims.objectbucket.io cephobjectzones.ceph.rook.io cephrbdmirrors.ceph.rook.io cephobjectzonegroups.ceph.rook.io cephobjectstoreusers.ceph.rook.io cephblockpools.ceph.rook.io cephobjectstores.ceph.rook.io cephobjectrealms.ceph.rook.io cephnfses.ceph.rook.io cephclients.ceph.rook.io cephfilesystemsubvolumegroups.ceph.rook.io cephfilesystemmirrors.ceph.rook.io cephclusters.ceph.rook.io cephbucketnotifications.ceph.rook.io cephbuckettopics.ceph.rook.io cephfilesystems.ceph.rook.io; do
for CRD in issuers.cert-manager.io orders.acme.cert-manager.io clusterissuers.cert-manager.io challenges.acme.cert-manager.io certificates.cert-manager.io certificaterequests.cert-manager.io; do
  # echo "Using following values..." \
  # echo Kind: $KIND \
  # echo NAME: $CRD \
  # echo RELEASE: $RELEASE \
  # echo NAMESPACE: $NAMESPACE \
  kubectl -n ${NAMESPACE} annotate ${KIND} ${CRD} meta.helm.sh/release-name=${RELEASE};
  kubectl -n ${NAMESPACE} annotate ${KIND} ${CRD} meta.helm.sh/release-namespace=${NAMESPACE};
  kubectl -n ${NAMESPACE} label $KIND ${CRD} app.kubernetes.io/managed-by=Helm;
done
# kubectl annotate $KIND $CRD meta.helm.sh/release-name=$RELEASE
# kubectl annotate $KIND $CRD meta.helm.sh/release-namespace=$NAMESPACE
# kubectl label $KIND $CRD app.kubernetes.io/managed-by=Helm
# cephblockpools.ceph.rook.io
# cephbucketnotifications.ceph.rook.io
# cephbuckettopics.ceph.rook.io
# cephclients.ceph.rook.io
# cephclusters.ceph.rook.io
# cephfilesystemmirrors.ceph.rook.io
# cephfilesystemsubvolumegroups.ceph.rook.io
# cephfilesystems.ceph.rook.io
# cephobjectstores.ceph.rook.io
# cephobjectrealms.ceph.rook.io
# cephobjectstoreusers.ceph.rook.io
# cephobjectzonegroups.ceph.rook.io
# cephobjectzones.ceph.rook.io
# cephrbdmirrors.ceph.rook.io
# objectbucketclaims.objectbucket.io
# objectbuckets.objectbucket.io

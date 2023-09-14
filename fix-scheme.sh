#!/usr/bin/env bash

tgt_ns=$(kubectl get svc -A -o jsonpath='{.items[?(@.metadata.annotations.policies\.kyverno\.io/last-applied-patches=="keycloak.apply-svc-dns-annotations.kyverno.io: added /metadata/annotations/traefik.ingress.kubernetes.io~1service.serversscheme\n")].metadata.namespace}')

echo $tgt_ns



for ng_tgt in $tgt_ns; do
    all_tgts=$(kubectl get svc -n $ng_tgt -o jsonpath='{.items[?(@.metadata.annotations.policies\.kyverno\.io/last-applied-patches=="keycloak.apply-svc-dns-annotations.kyverno.io: added /metadata/annotations/traefik.ingress.kubernetes.io~1service.serversscheme\n")].metadata.name}')

    echo "In ns $ng_tgt, identified svcs $all_tgts"
    for tgt in $all_tgts; do
        echo "removing annotation from svc/$tgt in namespace $ng_tgt"
        kubectl -n $ng_tgt annotate svc $tgt traefik.ingress.kubernetes.io/service.serversscheme-
    done
done

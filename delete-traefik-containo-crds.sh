#!/bin/bash
KIND=CustomResourceDefinition
NAMESPACE=networking

for CRD in ingressroutes.traefik.containo.us ingressroutetcps.traefik.containo.us ingressrouteudps.traefik.containo.us middlewares.traefik.containo.us middlewaretcps.traefik.containo.us traefikservices.traefik.containo.us tlsstores.traefik.containo.us tlsoptions.traefik.containo.us serverstransports.traefik.containo.us
  kubectl -n ${NAMESPACE} delete ${KIND} ${CRD}
done

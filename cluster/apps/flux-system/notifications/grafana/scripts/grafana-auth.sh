#!/bin/bash
set -o nounset
set -o errexit
export NAMESPACE=flux-system
export SECRET_NAME=grafana-auth-flux
# Check whether secret exists
if [[ -n $(kubectl -n ${NAMESPACE} get secret ${SECRET_NAME} --ignore-not-found) ]]
then
    echo "Secret Exists. Not Requesting Neu Token"
else
    echo "No secret exists with name ${SECRET_NAME}"
    # Add token acquisition logic here

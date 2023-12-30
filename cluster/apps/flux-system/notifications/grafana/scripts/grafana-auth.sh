#!/bin/bash
set -o nounset
set -o errexit
export NAMESPACE=flux-system
export IAM_SECRET_NAME=grafana-auth-flux
export SECRET_NAME=grafana-alerting-auth

if [[ -z ${XYZ_DOMAIN} ]]
then
  echo "XYZ_DOMAIN is not set!"
  exit 1
fi

export IAM_TOKEN_ENDPOINT=https://iam.${XYZ_DOMAIN}/realms/bloopnet/protocol/openid-connect/token

export IAM_CLIENT_ID=`kubectl -n ${NAMESPACE} get secret ${IAM_SECRET_NAME} --template={{.data.iam_client_id}} | base64 -d`
export IAM_CLIENT_SECRET=`kubectl -n ${NAMESPACE} get secret ${IAM_SECRET_NAME} --template={{.data.iam_client_secret}} | base64 -d`

function validateToken() {
    token=$1
    isactive = `curl -X POST \
      -d "client_id=${IAM_CLIENT_ID}" \
      -d "client_secret=${IAM_CLIENT_SECRET}" \
      -d "token=$token" \
      "${IAM_TOKEN_ENDPOINT}/introspect" | jq -r '.active'`
    return $isactive
}

function renewToken() {
    token=`curl -X POST \
      -d "client_id=${IAM_CLIENT_ID}" \
      -d "client_secret=${IAM_CLIENT_SECRET}" \
      -d "grant_type=client_credentials" \
      "${IAM_TOKEN_ENDPOINT}" | jq -r '.access_token'`
    # TODO: Add to secret
}

# Check whether secret exists
if [[ -n $(kubectl -n ${NAMESPACE} get secret ${SECRET_NAME} --ignore-not-found) ]]
then
    echo "Secret Exists. Validating Token"
    access_token=`kubectl -n ${NAMESPACE} get secret ${SECRET_NAME} --template={{.data.token}} | base64 -d`
    isvalid=`validateToken $access_token`
    if [[ isvalid ]]
    then
      echo "token is valid. Leaving it alone"
      exit 0
    else
      renewToken
    fi
else
    echo "No secret exists with name ${SECRET_NAME}. Will generate one..."
fi

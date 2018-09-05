#!/bin/bash

set -x

if [ -z "$VAULT_MINIO_READ_ACCESS_TOKEN" ]; then
    echo ERROR: VAULT_MINIO_READ_ACCESS_TOKEN environment variable missing.  Create this secret in OpenShift.
    exit 1
fi

SECRETS=`curl -H "X-Vault-Token: $VAULT_MINIO_READ_ACCESS_TOKEN" -X GET http://vault34-vault34.apps.home.labdroid.net/v1/secret/minio`

export MINIO_ACCESS_KEY=`echo $SECRETS | jq .data.MINIO_ACCESS_KEY`
export MINIO_SECRET_KEY=`echo $SECRETS | jq .data.MINIO_SECRET_KEY`

HOME="`pwd`"
$HOME/minio server --config-dir=$HOME/config $@ $HOME/data

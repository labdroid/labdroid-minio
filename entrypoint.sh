#!/bin/bash

set -x

if [ -z "$VAULT_MINIO_READ_ACCESS_TOKEN" ]; then
    echo ERROR: VAULT_MINIO_READ_ACCESS_TOKEN environment variable missing.  Create this secret in OpenShift.
    exit 1
fi

# Wait for vault to come up
attempt_counter=0
max_attempts=30
until $(curl --output /dev/null --silent --head --fail http://vault:8200/v1/sys/health); do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts to contact vault reached"
      exit 1
    fi
    printf '.'
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done


SECRETS=`curl -H "X-Vault-Token: $VAULT_MINIO_READ_ACCESS_TOKEN" -X GET http://vault:8200/v1/secret/minio`

export MINIO_ACCESS_KEY=`echo $SECRETS | jq -r .data.MINIO_ACCESS_KEY`
export MINIO_SECRET_KEY=`echo $SECRETS | jq -r .data.MINIO_SECRET_KEY`

# FIXME -- check for variable assignment. did they work?

HOME="`pwd`"
$HOME/minio server --config-dir=$HOME/config $@ $HOME/data

#!/bin/bash

if [ -z "$MINIO_ACCESS_KEY" ]; then
    echo ERROR: MINIO_ACCESS_KEY environment variable missing.  Create this secret in OpenShift.
    exit 1
fi
    
if [ -z "$MINIO_SECRET_KEY" ]; then
    echo ERROR: MINIO_SECRET_KEY environment variable missing.  Create this secret in OpenShift.
    exit 1
fi
    
HOME="`pwd`"
$HOME/minio server --config-dir=$HOME/config $@ $HOME/data

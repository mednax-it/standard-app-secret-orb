#!/usr/bin/env bash
set -e

echo "Logging in to az cli"
az login \
    --service-principal \
    --tenant $AZURE_SP_TENANT \
    -u $AZURE_SP \
    -p $AZURE_SP_PASSWORD

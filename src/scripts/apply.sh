#!/bin/bash
# This uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables

#!/usr/bin/env bash
# Verify the CLI isn't already installed
# Use which instead of command -v for wider coverage of envs
set -e

if which az > /dev/null;
then
  echo "Azure CLI installed already."
else
  apk add py3-pip
  apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
  pip install --break-system-packages --upgrade pip
  pip install --break-system-packages azure-cli
  echo "Azure CLI is now installed."
fi


echo "Logging in to az cli"
az login --service-principal \
    --tenant "$AZURE_TENANT" \
    -u "$AZURE_SERVICE_PRINCIPLE" \
    -p "$AZURE_SERVICE_PRINCIPLE_PASSWORD"
az account set --subscription "$SUBSCRIPTION"


TF_VAR_app_registration_id=$(circleci env subst "${PARAM_APP_REGISTRATION_ID}")
TF_VAR_resource_group_name=$(circleci env subst "${PARAM_RESOURCE_GROUP_NAME}")
TF_VAR_key_vault_name=$(circleci env subst "${PARAM_KEY_VAULT_NAME}")
TF_VAR_key_name=$(circleci env subst "${PARAM_KEY_NAME}")
export TF_VAR_app_registration_id
export TF_VAR_resource_group_name
export TF_VAR_key_vault_name
export TF_VAR_key_name

git clone git@github.com:mednax-it/standard-app-secret-generation.git
terraform -chdir=./standard-app-secret-generation init
terraform -chdir=./standard-app-secret-generation apply -auto-approve

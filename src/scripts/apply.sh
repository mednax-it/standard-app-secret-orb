#!/bin/bash
# This uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables

#!/usr/bin/env bash
# Verify the CLI isn't already installed
# Use which instead of command -v for wider coverage of envs
set -e

AZURE_TENANT=$(circleci env subst "${AZURE_TENANT}")
AZURE_SERVICE_PRINCIPLE=$(circleci env subst "${AZURE_SERVICE_PRINCIPLE}")
AZURE_SERVICE_PRINCIPLE_PASSWORD=$(circleci env subst "${AZURE_SERVICE_PRINCIPLE_PASSWORD}")
SUBSCRIPTION=$(circleci env subst "${SUBSCRIPTION}")

export AZURE_TENANT
export AZURE_SERVICE_PRINCIPLE
export AZURE_SERVICE_PRINCIPLE_PASSWORD
export SUBSCRIPTION

echo "Logging in to az cli"
az login --service-principal \
    --tenant "$AZURE_TENANT" \
    -u "$AZURE_SERVICE_PRINCIPLE" \
    -p "$AZURE_SERVICE_PRINCIPLE_PASSWORD"
az account set --subscription "$SUBSCRIPTION"

TF_VAR_resource_group_name=$(circleci env subst "${PARAM_RESOURCE_GROUP_NAME}")
TF_VAR_key_vault_name=$(circleci env subst "${PARAM_KEY_VAULT_NAME}")
TF_VAR_key_name=$(circleci env subst "${PARAM_KEY_NAME}")

export TF_VAR_resource_group_name
export TF_VAR_key_vault_name
export TF_VAR_key_name

if [[ -z "$PARAM_APP_REGISTRATION_ID" ]]; then
    echo "Retrieve app registration id for application ${PARAM_APP_REGISTRATION_DISPLAY_NAME}"
    TF_VAR_app_registration_id=$(az ad app list --display-name "${PARAM_APP_REGISTRATION_DISPLAY_NAME}" --query '[0].appId' -o tsv)
else
    TF_VAR_app_registration_id=$(circleci env subst "${PARAM_APP_REGISTRATION_ID}")
fi

export TF_VAR_app_registration_id

if [[ -z "$TF_VAR_app_registration_id" ]]; then
    echo "Error: unable to determine app registration id"
    exit 1
else
    echo "App registration id: $TF_VAR_app_registration_id"
fi

echo "Cloning terraform repo"
git clone https://github.com/mednax-it/standard-app-secret-generation.git

echo "Apply the terraform to check and potentially create/store the secret"
terraform -chdir=./standard-app-secret-generation init
terraform -chdir=./standard-app-secret-generation apply -auto-approve

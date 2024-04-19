#!/bin/bash
# This uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables

#!/usr/bin/env bash
# Verify the CLI isn't already installed
# Use which instead of command -v for wider coverage of envs
set -e

if which az > /dev/null; then
  echo "Azure CLI installed already."
  exit 0
fi

# Set sudo to work whether logged in as root user or non-root user

if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi

apk add py3-pip
apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
pip install --upgrade pip
pip install azure-cli

#apt-get update && apt-get -qqy install apt-transport-https

# if [[ $(command -v lsb_release) == "" ]]; then
#   echo "Installing lsb_release"
#   $SUDO apt-get -qqy install lsb-release
# fi
#
# # Create an environment variable for the correct distribution
# AZ_REPO=$(lsb_release -cs)
# export AZ_REPO
#
# # Modify your sources list
#
# echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#   $SUDO tee /etc/apt/sources.list.d/azure-cli.list
#
# if [[ $(command -v curl) == "" ]]; then
#   echo "Installing curl"
#   $SUDO apt-get -qqy install curl
# fi
#
# # Get the Microsoft signing key
#
# curl -L https://packages.microsoft.com/keys/microsoft.asc | $SUDO apt-key add -
#
# # Update and install the Azure CLI
#
# $SUDO apt-get update
# $SUDO apt-get -qqy install \
#   ca-certificates \
#   azure-cli
echo "Azure CLI is now installed."

echo "Logging in to az cli"
az login \
    --service-principal \
    --tenant "$AZURE_SP_TENANT" \
    -u "$AZURE_SP" \
    -p "$AZURE_SP_PASSWORD"

TF_VAR_app_registration_id=$(circleci env subst "${PARAM_APP_REGISTRATION_ID}")
TF_VAR_resource_group_name=$(circleci env subst "${PARAM_RESOURCE_GROUP_NAME}")
TF_VAR_key_vault_name=$(circleci env subst "${PARAM_KEY_VAULT_NAME}")
TF_VAR_key_name=$(circleci env subst "${PARAM_KEY_NAME}")
export TF_VAR_app_registration_id
export TF_VAR_resource_group_name
export TF_VAR_key_vault_name
export TF_VAR_key_name

echo "App Registration = ${TF_VAR_app_registration_id}!"
echo "Resource Group Name = ${TF_VAR_resource_group_name}!"
echo "Key Vault Name = ${TF_VAR_key_vault_name}!"
echo "Key Name = ${TF_VAR_key_name}!"

git clone git@github.com:mednax-it/standard-app-secret-generation.git
terraform -chdir=./standard-app-secret-generation init
terraform -chdir=./standard-app-secret-generation plan # This is only temporary to validate the orb since we've never done this before
#terraform -chdir=./standard-app-secret-generation apply -auto-approve

#!/bin/bash
# This uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables
TF_VAR_app_registration_id=$(circleci env subst "${PARAM_APP_REGISTRATION_ID}")
TF_VAR_resource_group_name=$(circleci env subst "${PARAM_RESOURCE_GROUP_NAME}")
TF_VAR_key_vault_name=$(circleci env subst "${PARAM_KEY_VAULT_NAME}")
TF_VAR_key_name=$(circleci env subst "${PARAM_KEY_NAME}")

echo "App Registration = ${TF_VAR_app_registration_id}!"
echo "Resource Group Name = ${TF_VAR_resource_group_name}!"
echo "Key Vault Name = ${TF_VAR_key_vault_name}!"
echo "Key Name = ${TF_VAR_key_name}!"

git clone git@github.com:mednax-it/standard-app-secret-generation.git
terraform -chdir=./standard-app-secret-generation init
terraform -chdir=./standard-app-secret-generation plan # This is only temporary to validate the orb since we've never done this before
#terraform -chdir=./standard-app-secret-generation apply -auto-approve

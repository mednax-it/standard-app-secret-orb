#!/bin/bash
# This example uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables
TF_VAR_app_registration_id=$(circleci env subst "${app_registration_id}")
TF_VAR_resource_group_name=$(circleci env subst "${resource_group_name}")
TF_VAR_key_vault_name=$(circleci env subst "${key_vault_name}")
TF_VAR_key_name=$(circleci env subst "${key_name}")
# If for any reason the TO variable is not set, default to "World"
echo "App Registration = ${TF_VAR_app_registration_id}!"
echo "Resource Group Name = ${TF_VAR_resource_group_name}!"
echo "Key Vault Name = ${TF_VAR_key_vault_name}!"
echo "Key Name = ${TF_VAR_key_name}!"

git clone git@github.com:mednax-it/standard-app-secret-generation.git
terraform -chdir=./standard-app-secret-generation init
terraform -chdir=./standard-app-secret-generation apply -auto-approve

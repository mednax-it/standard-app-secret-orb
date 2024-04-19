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

$SUDO apt-get update && $SUDO apt-get -qqy install apt-transport-https

if [[ $(command -v lsb_release) == "" ]]; then
  echo "Installing lsb_release"
  $SUDO apt-get -qqy install lsb-release
fi

# Create an environment variable for the correct distribution
export AZ_REPO=$(lsb_release -cs)

# Modify your sources list

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
  $SUDO tee /etc/apt/sources.list.d/azure-cli.list

if [[ $(command -v curl) == "" ]]; then
  echo "Installing curl"
  $SUDO apt-get -qqy install curl
fi

# Get the Microsoft signing key

curl -L https://packages.microsoft.com/keys/microsoft.asc | $SUDO apt-key add -

# Update and install the Azure CLI

$SUDO apt-get update
$SUDO apt-get -qqy install \
  ca-certificates \
  azure-cli
echo "Azure CLI is now installed."
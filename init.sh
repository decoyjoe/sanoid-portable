#!/bin/bash

set -euo pipefail

# Identify the operating system from /etc/os-release
OS=$(grep ^ID= /etc/os-release | cut -d '=' -f 2 | tr -d '"')

# Check if the OS is Debian or a Debian derivative (like Ubuntu)
if [[ "$OS" != 'debian' && "$OS" != 'ubuntu' ]]; then
  echo 'Error: This script is intended only for Debian-based systems.'
  exit 1
fi

# Determine whether to use 'sudo' or run directly (if root)
if [[ "$EUID" -ne 0 ]]; then
  SUDO='sudo'
else
  SUDO=''
fi

# Update package lists to ensure packages are up to date
$SUDO apt-get update

$SUDO apt-get install -y build-essential wget git unzip zip jq

echo ''
echo 'All necessary dependencies have been installed.'
echo ''

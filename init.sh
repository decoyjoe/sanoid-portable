#!/usr/bin/env bash

set -euo pipefail

# Identify the operating system from /etc/os-release
source /etc/os-release
OS=$ID

# The only build OS's we've tested.
if [[ "$OS" != 'debian' && "$OS" != 'ubuntu' ]]; then
  echo "Error: Unsupported operating system. This script only supports Debian and Ubuntu."
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

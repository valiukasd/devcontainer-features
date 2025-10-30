#!/bin/sh

set -e

CLI_VERSION="${VERSION:-"latest"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release

# Get an adjusted ID independent of distro variants
if [ "${ID}" != "debian" ] && [ "${ID_LIKE}" != "debian" ]; then
    echo "Linux distro ${ID} not supported."
    exit 1
fi

# Install prerequisites
apt-get -y update
apt-get -y install --no-install-recommends curl ca-certificates

# Run setup script
curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash
apt-get -y update

# Install latest or selected version
if [ "${CLI_VERSION}" = "latest" ]; then
    apt-get -y install infisical
else
    apt-get -y install "infisical=${CLI_VERSION}"
fi

# Clean up
apt-get -y clean
rm -rf /var/lib/apt/lists/*

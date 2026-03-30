#!/bin/bash -eu

# Install Zoom 6.4.6.1370 (downgrade from 7.x)
# This downloads the last available 6.x .deb from Zoom's CDN and installs it.

ZOOM_VERSION="6.4.6.1370"
ZOOM_URL="https://cdn.zoom.us/prod/${ZOOM_VERSION}/zoom_amd64.deb"
TMPFILE=$(mktemp /tmp/zoom_XXXXXX.deb)

cleanup() {
    rm -f "${TMPFILE}"
}
trap cleanup EXIT

echo "Downloading Zoom ${ZOOM_VERSION}..."
wget -O "${TMPFILE}" "${ZOOM_URL}"

echo "Installing Zoom ${ZOOM_VERSION} (will downgrade if newer version is installed)..."
sudo dpkg -i "${TMPFILE}" || sudo apt-get install -f -y

echo "Installed version:"
dpkg -l zoom | tail -1

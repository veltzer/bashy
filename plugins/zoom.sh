# this is a plugin for zoom

function _install_zoom_latest_force() {
  # old version - always downloads and installs
	before_strict
	url="https://zoom.us/client/latest/zoom_amd64.deb"
	local_file="/tmp/zoom_amd64.deb"
	curl --fail --location --silent --output "${local_file}" "${url}"
	sudo dpkg --install "${local_file}"
	after_strict
}

function _install_zoom_latest() {
	before_strict
	url="https://zoom.us/client/latest/zoom_amd64.deb"
	local_file="/tmp/zoom_amd64.deb"
	# Extract remote version from the redirect URL
	remote_version=$(curl --fail --silent --head --location --output /dev/null --write-out '%{url_effective}' "${url}" | grep -oP '/prod/\K[^/]+')
	# Get installed version (empty if not installed)
	installed_version=$(dpkg-query -W -f='${Version}' zoom 2>/dev/null || true)
	if [ "${installed_version}" = "${remote_version}" ]
  then
		echo "zoom is already up to date (${installed_version})"
		after_strict
		return
	fi
	echo "Upgrading zoom from [${installed_version:-not installed}] to [${remote_version}]"
	curl --fail --location --silent --output "${local_file}" "${url}"
	sudo dpkg --install "${local_file}"
	after_strict
}

function _install_zoom_6() {
  # Install Zoom 6.4.6.1370 (downgrade from 7.x)
  # This downloads the last available 6.x .deb from Zoom's CDN and installs it.

  ZOOM_VERSION="6.4.6.1370"
  ZOOM_URL="https://cdn.zoom.us/prod/${ZOOM_VERSION}/zoom_amd64.deb"
  TMPFILE=$(mktemp /tmp/zoom_XXXXXX.deb)

  echo "Downloading Zoom ${ZOOM_VERSION}..."
  wget -O "${TMPFILE}" "${ZOOM_URL}"

  echo "Installing Zoom ${ZOOM_VERSION} (will downgrade if newer version is installed)..."
  sudo dpkg -i "${TMPFILE}" || sudo apt-get install -f -y
  echo "Installed version:"
  dpkg -l zoom | tail -1
}

function _uninstall_zoom() {
	before_strict
	sudo dpkg --purge zoom
	after_strict
}

function _activate_zoom() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register_interactive _activate_zoom

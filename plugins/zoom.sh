# this is a plugin for zoom

# old version - always downloads and installs
function _install_zoom_old() {
	before_strict
	url="https://zoom.us/client/latest/zoom_amd64.deb"
	local_file="/tmp/zoom_amd64.deb"
	curl --fail --location --silent --output "${local_file}" "${url}"
	sudo dpkg --install "${local_file}"
	after_strict
}

function _install_zoom() {
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

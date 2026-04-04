# this is a plugin for freetube

function _install_freetube_latest() {
	before_strict
	url=$(curl --fail --silent "https://api.github.com/repos/FreeTubeApp/FreeTube/releases" | grep -oP '"browser_download_url": "\K[^"]*amd64\.deb' | head -1)
	if [ -z "${url}" ]; then
		echo "ERROR: could not find FreeTube .deb download URL"
		after_strict
		return 1
	fi
	local_file="/tmp/freetube_amd64.deb"
	echo "Downloading FreeTube from [${url}]..."
	curl --fail --location --silent --output "${local_file}" "${url}"
	sudo dpkg --install "${local_file}" || sudo apt-get install -f -y
	after_strict
}

function _uninstall_freetube() {
	before_strict
	sudo dpkg --purge freetube
	after_strict
}

function _activate_freetube() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register_interactive _activate_freetube

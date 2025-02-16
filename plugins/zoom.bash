# this is a plugin for zoom

function _install_zoom() {
	before_strict
	url="https://zoom.us/client/latest/zoom_amd64.deb"
	local_file="/tmp/zoom_amd64.deb"
	curl --location --silent --output "${local_file}" "${url}"
	sudo dpkg --install "${local_file}"
	after_strict
}

function _uninstall_zoom() {
	set -e
	sudo dpkg --purge zoom
	set +e
}

function _activate_zoom() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register_interactive _activate_zoom

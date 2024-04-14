function _activate_go() {
	local -n __var=$1
	local -n __error=$2
	GO_HOME="${HOME}/install/go"
	local GO_BIN="${GO_HOME}/bin"
	if ! checkDirectoryExists "${GO_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${GO_BIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${GO_BIN}"
	export GO_HOME
	__var=0
}

function _install_go() {
	set +e
	# https://go.dev/dl/
	version="1.22.1"
	url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"
	folder="${HOME}/install/"
	full_folder="${folder}/go"
	rm -rf "${full_folder}"
	curl --location --silent "${url}" | tar xz -C "${folder}"
	set -e
}

register _activate_go

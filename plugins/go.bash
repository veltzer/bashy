function _activate_go() {
	local -n __var=$1
	local -n __error=$2
	GO_PATH="${HOME}/install/go"
	local GO_PATHBIN="${GO_PATH}/bin"
	if ! checkDirectoryExists "${GO_PATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${GO_PATHBIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${GO_PATHBIN}"
	export GO_PATH
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

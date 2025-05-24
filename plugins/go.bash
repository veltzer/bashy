function _activate_go() {
	local -n __var=$1
	local -n __error=$2
	GOPATH="${HOME}/.cache/go"
	GO_HOME="${HOME}/install/go"
	local GO_BIN="${GO_HOME}/bin"
	if ! checkDirectoryExists "${GO_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${GO_BIN}" __var __error; then return; fi
	# export GO_HOME
	# export GOPATH
	_bashy_pathutils_add_head PATH "${GO_BIN}"
	_bashy_pathutils_add_head PATH "${GOPATH}/bin"
	complete -C gocomplete go
	__var=0
}

function _install_go() {
	before_strict
	# https://go.dev/dl/
	version="1.22.1"
	url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"
	folder="${HOME}/install/"
	full_folder="${folder}/go"
	rm -rf "${full_folder}"
	curl --location --silent "${url}" | tar xz -C "${folder}"
	after_strict
}

register _activate_go

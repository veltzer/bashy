# GOBIN - is where executbles are installed
# GOPATH - is where go is installed
# You don't need them both as executables are installed into ${GOPATH}/bin if ${GOBIN} is undefined.
# ~/.cache/go-build is where the go cache is
# GOROOT - where go is installed


function _activate_go() {
	local -n __var=$1
	local -n __error=$2
	# GOPATH="${HOME}/.cache/go"
	GOROOT="${HOME}/install/go"
	GOPATH="${HOME}/install/gopath"
	GOBIN="${GOPATH}/bin"
	if ! checkDirectoryExists "${GOROOT}" __var __error; then return; fi
	if ! checkDirectoryExists "${GOPATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${GOBIN}" __var __error; then return; fi
	export GOPATH
	# export GOBIN
	_bashy_pathutils_add_head PATH "${GOBIN}"
	complete -C gocomplete go
	__var=0
}

function _install_go() {
	before_strict
	# https://go.dev/dl/
	folder="${HOME}/install/"
	full_folder="${folder}/go"
	rm -rf "${full_folder}"
	version=$(curl --fail --show-error --silent "https://go.dev/VERSION?m=text" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")
	# version="1.22.1"
	echo "installing version ${version}..."
	url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"
	curl --fail --location --silent "${url}" | tar xz -C "${folder}"
	rm -rf "${HOME}/.cache/go-build" "${HOME}/install/gopath"
	mkdir -p "${HOME}/install/gopath/bin"
	after_strict
}

register _activate_go

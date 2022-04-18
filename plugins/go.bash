function configure_go() {
	local -n __var=$1
	local -n __error=$2
	local GOPATHBIN="${GOPATH}/bin"
	if ! checkDirectoryExists "$GOPATH" __var __error; then return; fi
	if ! checkDirectoryExists "$GOPATHBIN" __var __error; then return; fi
	pathutils_add_head PATH "${GOPATHBIN}"
	export GOPATH
	__var=0
}

register configure_go

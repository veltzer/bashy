function configure_go() {
	local -v __var=$1
	GOPATH="${HOME}/install/go"
	GOPATHBIN="${GOPATH}/bin"
	if [ -d "$GOPATH" ] && [ -d "$GOPATHBIN" ]
	then
		pathutils_add_head PATH "${GOPATHBIN}"
		export GOPATH
		__var=0
		return
	fi
	__var=1
}

register configure_go

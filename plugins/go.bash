function configure_go() {
	local -n __var=$1
	local -n __error=$2
	GOPATH="${HOME}/install/go"
	GOPATHBIN="${GOPATH}/bin"
	if [ ! -d "$GOPATH" ] || [ ! -d "$GOPATHBIN" ]
	then
		__error="[$GOPATH] or [$GOPATHBIN] dont exist"
		__var=1
		return
	fi
	pathutils_add_head PATH "${GOPATHBIN}"
	export GOPATH
	__var=0
}

register configure_go

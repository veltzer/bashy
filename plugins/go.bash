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

register _activate_go

function _activate_phantomjs() {
	local -n __var=$1
	local -n __error=$2
	PHANTOMJSPATH="${HOME}/install/phantomjs"
	PHANTOMJSPATHBIN="${PHANTOMJSPATH}/bin"
	if ! checkDirectoryExists "${PHANTOMJSPATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${PHANTOMJSPATHBIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${PHANTOMJSPATHBIN}"
	export PHANTOMJSPATH
	__var=0
}

register _activate_phantomjs

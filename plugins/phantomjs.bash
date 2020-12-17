function configure_phantomjs() {
	local -n __var=$1
	PHANTOMJSPATH="${HOME}/install/phantomjs"
	PHANTOMJSPATHBIN="${PHANTOMJSPATH}/bin"
	if [ -d "$PHANTOMJSPATH" ] && [ -d "$PHANTOMJSPATHBIN" ]
	then
		pathutils_add_head PATH "${PHANTOMJSPATHBIN}"
		export PHANTOMJSPATH
		__var=0
		return
	fi
	__var=1
}

register configure_phantomjs

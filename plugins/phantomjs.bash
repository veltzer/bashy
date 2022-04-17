function configure_phantomjs() {
	local -n __var=$1
	local -n __error=$2
	PHANTOMJSPATH="${HOME}/install/phantomjs"
	PHANTOMJSPATHBIN="${PHANTOMJSPATH}/bin"
	if [ ! -d "$PHANTOMJSPATH" ] || [ ! -d "$PHANTOMJSPATHBIN" ]
	then
		__error="[$PHANTOMJSPATH] or [$PHANTOMJSPATHBIN] dont exist"
		__var=1
		return
	fi
	pathutils_add_head PATH "${PHANTOMJSPATHBIN}"
	export PHANTOMJSPATH
	__var=0
}

register configure_phantomjs

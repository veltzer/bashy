function pathutils_add_head() {
	# pypathutil_add "$1" "$2"
	local IFS=':'
	local -a path
	local -A map
	for DIR in $1; do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]; then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	path=($2 "${path[@]}")
	echo "${path[*]}"
}

function pathutils_add_tail() {
	# pypathutil_add --tail "$1" "$2"
	local IFS=':'
	local -a path
	local -A map
	for DIR in $1; do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]; then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	path+=($2)
	echo "${path[*]}"
}

function pathutils_remove() {
	# pypathutil_remove "$1" "$2"
	local IFS=':'
	local -a path
	local -A map
	for DIR in $1; do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]; then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	echo "${path[*]}"
}

function pathutils_is_in_path() {
	local prog=$1
	hash $prog 2> /dev/null
}

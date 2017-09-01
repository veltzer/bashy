function pathutils_add_head() {
	# pypathutil_add "$1" "$2"
	local __user_var=$1
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]
		then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	path=($2 "${path[@]}")
	eval $__user_var="${path[*]}"
}

function pathutils_add_tail() {
	local __user_var=$1
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]
		then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	path+=($2)
	eval $__user_var="${path[*]}"
}

function pathutils_remove() {
	local __user_var=$1
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "$2" ] && [ "${map[$DIR]}" != "yes" ]
		then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	eval $__user_var="${path[*]}"
}

function pathutils_is_in_path() {
	local prog=$1
	hash $prog 2> /dev/null
}

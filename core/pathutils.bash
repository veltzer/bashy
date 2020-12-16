function pathutils_add_head() {
	local __user_var=$1
	local add=$2
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "add" ] && ! [ "${map[$DIR]+muhaha}" ]
		then
			path+=($DIR)
			map[$DIR]="yes"
		fi
	done
	path=("$add" "${path[@]}")
	eval "$__user_var='${path[*]}'"
}

function pathutils_add_tail() {
	local __user_var=$1
	local add=$2
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "$add" ] && ! [ "${map[$DIR]+muhaha}" ]
		then
			path+=("$DIR")
			map[$DIR]="yes"
		fi
	done
	path+=("$add")
	eval "$__user_var='${path[*]}'"
}

function pathutils_remove() {
	local __user_var=$1
	local remove=$2
	local IFS=':'
	local -a path
	local -A map
	local tmp
	eval tmp=\$$__user_var
	for DIR in $tmp
	do
		if [ "$DIR" != "$remove" ] && ! [ "${map[$DIR]+muhaha}" ]
		then
			path+=("$DIR")
			map[$DIR]="yes"
		fi
	done
	eval "$__user_var='${path[*]}'"
}

function pathutils_is_in_path() {
	local result=0
	for x in "$@"
	do
		if ! hash "$x" 2> /dev/null
		then
			result=1
		fi
	done
	return $result
}

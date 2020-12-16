# A set of functions to help with dealing with arrays

function array_new() {
	local __user_var=$1
	declare -ga "$__user_var"
}

function array_set() {
	local -n __array=$1
	local pos=$2
	local value=$3
	__array[$pos]=$value
}

function array_print() {
	local -n __array=$1
	echo "length of array is ${#__array[@]}"
	for index in "${!__array[@]}"
	do
		echo "$index/${__array[$index]}"
	done
}

function array_length() {
	local -n __array=$1
	local -n var=$2
	var=${#__array[@]}
}

function array_push() {
	local -n __array=$1
	local var=$2
	__array+=("$var")
}

function array_pop() {
	local -n __array=$1
	local -n var=$2
	var=${__array[${#__array[@]}-1]}
	unset '__array[${#__array[@]}-1]'
}

function array_is_array() {
	local array_name=$1
	local declare_output
	declare_output=$(declare -p "$array_name")
	[[ "$declare_output" =~ "declare -a" ]]
}

function array_find() {
	local -n __array=$1
	local value=$2
	local -n __array_location=$3
	__array_location=0
	for item in "${__array[@]}"; do
		if [ "$item" = "$value" ]
		then
			return
		fi
		((__array_location++))
	done
	__array_location=-1
}

function array_contains() {
	local -n __array=$1
	local value=$2
	for item in "${__array[@]}"; do
		[ "$item" = "$value" ] && return 0
	done
	return 1
}

function array_remove() {
	local -n __array=$1
	local value=$2
	array_new new_array
	for elem in "${__array[@]}"
	do
		if [[ "$elem" != "$value" ]]
		then
			array_push new_array "$elem"
		fi
	done
	__array=("${new_array[@]}")
	unset new_array
}

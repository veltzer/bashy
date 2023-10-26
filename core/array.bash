# A set of functions to help with dealing with arrays

function array_new() {
	local __user_var=$1
	declare -ga "${__user_var}=()"
}

function array_set() {
	local -n __array_set=$1
	local pos=$2
	local value=$3
	__array_set[pos]="${value}"
}

function array_print() {
	# shellcheck disable=2178
	local -n __array_print=$1
	echo "length of array is ${#__array_print[@]}"
	for index in "${!__array_print[@]}"
	do
		echo "${index}/${__array_print[${index}]}"
	done
}

function array_length() {
	# shellcheck disable=2178
	local -n __array_length=$1
	local -n var=$2
	var=${#__array_length[@]}
}

function array_push() {
	# shellcheck disable=2178
	local -n __array_push=$1
	local var=$2
	__array_push+=("${var}")
}

function array_pop() {
	# shellcheck disable=2178
	local -n __array_pop=$1
	local -n var=$2
	var=${__array_pop[${#__array_pop[@]}-1]}
	unset "__array_pop[${#__array_pop[@]}-1]"
}

function array_is_array() {
	local array_name=$1
	local declare_output
	declare_output=$(declare -p "${array_name}")
	[[ "${declare_output}" =~ "declare -a" ]]
}

function array_find() {
	# shellcheck disable=2178
	local -n __array_find=$1
	local value=$2
	local -n __array_location=$3
	__array_location=0
	for item in "${__array_find[@]}"; do
		if [ "${item}" = "${value}" ]
		then
			return
		fi
		((__array_location++))
	done
	__array_location=-1
}

function array_contains() {
	# shellcheck disable=2178
	local -n __array_contains=$1
	local value=$2
	for item in "${__array_contains[@]}"; do
		[ "${item}" = "${value}" ] && return 0
	done
	return 1
}

function array_remove() {
	# shellcheck disable=2178
	local -n __array_remove=$1
	local value=$2
	array_new new_array
	for elem in "${__array_remove[@]}"
	do
		if [[ "${elem}" != "${value}" ]]
		then
			array_push new_array "${elem}"
		fi
	done
	__array=("${new_array[@]}")
	unset new_array
}

# This file defines helpers for dealing with associative arrays
# in bash
#
# References:
# - http://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
# - https://stackoverflow.com/questions/23167047/bash-parse-arrays-from-config-file

source_relative null.bash

# This is a function that creates a new global associative array in a variable
# name of your choosing.
# Note the -g flag which makes a global associative array. It is necessary,
# otherwise the associative array which is created will be local.
function assoc_new() {
	local __user_var=$1
	declare -gA "$__user_var=()"
}

# This is a function that returns an associative arrays length
function assoc_len() {
	local -n __assoc=$1
	local -n __var=$2
	__var=${#__assoc[@]}
}

# This is a function to print out an associative array.
# It has been checked to handle associative arrays which have spaces
# in the keys or values correctly.
function assoc_print() {
	local -n __assoc=$1
	local key
	for key in "${!__assoc[@]}"
	do
		local val=${__assoc[$key]}
		echo "$key --> $val"
	done
}

function assoc_set() {
	local -n __assoc_set=$1
	local key=$2
	local value=$3
	__assoc_set[$key]=$value
}

function assoc_get() {
	local -n __assoc=$1
	local -n __var=$2
	local key=$3
	if assoc_key_exists __assoc "$key"
	then
		__var=${__assoc[$key]}
	else
		null_set_value __var
	fi
}

function assoc_config_read() {
	local -n __assoc=$1
	local filename=$2
	while read -r line
	do
		if [[ $line =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]
		then
			assoc_set __assoc "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
		fi
	done < "$filename"
}

function assoc_key_exists() {
	local -n __assoc_key=$1
	local key=$2
	[ ${__assoc_key[$key]+muhaha} ]
}

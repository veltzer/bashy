# This file defines helpers for dealing with associative arrays
# in bash
#
# References:
# - http://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
# - https://stackoverflow.com/questions/23167047/bash-parse-arrays-from-config-file

source_relative null.bash

# This is a function that returns an associative arrays length
function assoc_len() {
	local -n __assoc_name=$1
	local -n __var=$2
	__var=${#__assoc_name[@]}
}

# This is a function to print out an associative array.
# It has been checked to handle associative arrays which have spaces
# in the keys or values correctly.
function assoc_print() {
	local __assoc_name=$1
	eval 'local keys=("${!'$__assoc_name'[@]}")'
	eval 'local len=${#'$__assoc_name'[@]}'
	local i
	for (( i=0; $i < $len; i+=1 ))
	do
		local key=${keys[$i]}
		eval "local val=\${$__assoc_name['$key']}"
		echo "$key --> $val"
	done
}

# This is a function that creates a new global associative array in a variable
# name of your choosing.
# Note the -g flag which makes a global associative array. It is necessary,
# otherwise the associative array which is created will be local.
function assoc_create() {
	local __assoc_name=$1
	eval "declare -gA $__assoc_name=()"
}

function assoc_set() {
	local __assoc_name=$1
	local key=$2
	local value=$3
	eval "$__assoc_name['$key']='$value'"
}

function assoc_get() {
	local __assoc_name=$1
	local __var_name=$2
	local key=$3
	if assoc_key_exists "$__assoc_name" "$key"
	then
		eval "$__var_name=\${$__assoc_name['$key']}"
	else
		null_get_value "$__var_name"
	fi
}

function assoc_config_read() {
	local __assoc_name=$1
	local filename=$2
	file="/etc/passwd"
	while read -r line
	do
		if [[ $line =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]
		then
			assoc_set "$__assoc_name" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
		fi
	done < "$filename"
}

function assoc_key_exists() {
	local __assoc_name=$1
	local key=$2
	eval "[ \${$__assoc_name['$key']+muahaha} ]"
}

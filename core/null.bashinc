# These are function that handle the null value in bash

function null_is_null() {
	local value=$1
	[ "$value" = 'NULL' ]
}

function null_isnt_null() {
	local value=$1
	[ "$value" != 'NULL' ]
}

function null_get_value() {
	local __var_name=$1
	eval "$__var_name='NULL'"
}

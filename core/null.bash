# These are function that handle the null value in bash

function null_is_null() {
	local value=$1
	[ "$value" = 'NULL' ]
}

function null_var_is_null() {
	local -n value=$1
	[ "$value" = 'NULL' ]
}

function null_isnt_null() {
	local value=$1
	[ "$value" != 'NULL' ]
}

function null_set_value() {
	local -n __var_null=$1
	__var_null='NULL'
}

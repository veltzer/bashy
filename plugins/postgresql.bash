function configure_postgresql() {
	local __user_var=$1
	# this configures the default options for postgresql
	if pathutils_is_in_path psql
	then
		export PGDATABASE=postgres
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_postgresql

function configure_pymultigit() {
	local __user_var=$1
	# these are aliases for pymultigit
	alias mg=pymultigit
	var_set_by_name "$__user_var" 0
}

register_interactive configure_pymultigit

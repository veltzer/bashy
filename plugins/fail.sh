function configure_fail() {
	local __user_var=$1
	var_set_by_name "$__user_var" 1
}

register configure_fail

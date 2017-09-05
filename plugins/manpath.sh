function configure_manpath() {
	local __user_var=$1
	# this causes MANPATH to always have a terminating colon which will
	# cause man(1) to always consult standard paths (from manpath(1)).
	export MANPATH=:
	var_set_by_name "$__user_var" 0
}

register_interactive configure_manpath

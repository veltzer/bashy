# This is integration of gh

function configure_gh() {
	local __user_var=$1
	if pathutils_is_in_path gh
	then
		eval "$(gh completion -s bash)"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_gh

function configure_fuck() {
	local __user_var=$1
	if pathutils_is_in_path thefuck
	then
		eval "$(thefuck --alias)"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

function install_fuck() {
	if pathutils_is_in_path pip3
	then
		sudo pip3 install thefuck
	fi
}

register_interactive configure_fuck

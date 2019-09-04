function configure_pureline() {
	local __user_var=$1
	if [ -r "$HOME/install/pureline/pureline" ]
	then
		source "$HOME/install/pureline/pureline" "$HOME/.pureline.conf"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_pureline

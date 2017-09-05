function configure_bash_completions_aws() {
	local __user_var=$1
	# completions for aws (must have 'awscli' package from ubuntu
	# or python module installed)
	if pathutils_is_in_path aws_completer
	then
		complete -C aws_completer aws
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_bash_completions_aws

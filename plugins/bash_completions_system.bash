function configure_bash_completions_system() {
	local __user_var=$1
	if [ -r /usr/share/bash-completion/bash_completion ]
	then
		bashy_before_thirdparty
		source /usr/share/bash-completion/bash_completion
		bashy_after_thirdparty
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_bash_completions_system

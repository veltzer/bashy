function configure_bash_completions_system() {
	local __user_var=$1
	if [ -f /usr/share/bash-completion/bash_completion ]
	then
		# we surround the source statement with 'bashy_before_thirdparty', 'bashy_after_thirdparty'
		# because I found the system bash completions sometimes have errors in them
		bashy_before_thirdparty
		source /usr/share/bash-completion/bash_completion
		bashy_after_thirdparty
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_bash_completions_system

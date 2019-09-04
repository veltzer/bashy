function configure_bash_powerline_shell() {
	local __user_var=$1
	if [ -r "$HOME/install/bash-powerline-shell/ps1_prompt" ]
	then
		source "$HOME/install/bash-powerline-shell/ps1_prompt"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_bash_powerline_shell

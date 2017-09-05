# This runs tmux at the start of a session.

function configure_tmux() {
	local __user_var=$1
	if pathutils_is_in_path tmux
	then
		if [[ -z ${TMUX+x} ]]
		then
			#exec tmux attach
			exec tmux
		fi
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_tmux

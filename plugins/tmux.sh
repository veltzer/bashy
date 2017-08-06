# This runs tmux at the start of a session.

function configure_tmux() {
	if pathutils_is_in_path tmux
	then
		if [[ -z ${TMUX+x} ]]
		then
			exec tmux
		fi
		result=0
	else
		result=1
	fi
}

register_interactive configure_tmux

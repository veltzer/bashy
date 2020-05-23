# This runs tmux at the start of a session.
#
# References:
# - https://davidtranscend.com/blog/check-tmux-session-exists-script/

function configure_tmux() {
	local __user_var=$1
	if pathutils_is_in_path tmux
	then
		# if not in tmux
		if [[ -z ${TMUX+x} ]]
		then
			session="workspace"
			if tmux has-session -t $session 2> /dev/null
			then
				exec tmux attach-session -t $session
			else
				exec tmux new-session -s $session
			fi
		fi
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_tmux

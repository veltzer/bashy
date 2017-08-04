function configure_bash_completions_system() {
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		# we surround the source statement with 'before_uncertain', 'after_uncertain'
		# because I found the system bash completions sometimes have errors in them
		before_uncertain
		source /usr/share/bash-completion/bash_completion
		after_uncertain
		return 0
	else
		return 1
	fi
}

register_interactive configure_bash_completions_system

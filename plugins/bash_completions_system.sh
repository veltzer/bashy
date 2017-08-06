function configure_bash_completions_system() {
	if [ -f /usr/share/bash-completion/bash_completion ]
	then
		# we surround the source statement with 'bashy_before_uncertain', 'bashy_after_uncertain'
		# because I found the system bash completions sometimes have errors in them
		bashy_before_uncertain
		source /usr/share/bash-completion/bash_completion
		bashy_after_uncertain
		result=0
	else
		result=1
	fi
}

register_interactive configure_bash_completions_system

function configure_bash_completions_own() {
	# my own bash completions
	# note that the 'source' command in bash cannot
	# sources more than one file at a time so we must
	# use the loop below....
	if [ -d "$HOME/.bash_completion.d/" ]; then
		# check if there are files matching the pattern
		if compgen -G "$HOME/.bash_completion.d/*" > /dev/null; then
			# source the files
			for x in ~/.bash_completion.d/*; do
				if [ -r "$x" ]; then
					source "$x"
					ret=$?
					if [ $ret != 0 ]
					then
						return 1
					fi
				else
					return 1
				fi
			done
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
}

register_interactive configure_bash_completions_own

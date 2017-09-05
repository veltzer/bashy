function configure_bash_completions_userdir() {
	local __user_var=$1
	# my own bash completions
	# note that the 'source' command in bash cannot
	# sources more than one file at a time so we must
	# use the loop below....
	if [ -d "$HOME/.bash_completion.d/" ]
	then
		# check if there are files matching the pattern
		if compgen -G "$HOME/.bash_completion.d/*" > /dev/null
		then
			# source the files
			for x in ~/.bash_completion.d/*
			do
				if [ -r "$x" ]
				then
					source "$x"
				fi
			done
		fi
	fi
	var_set_by_name "$__user_var" 0
}

register_interactive configure_bash_completions_userdir

function configure_bash_completions_aws() {
	# completions for aws (must have 'awscli' package from ubuntu
	# or python module installed)
	if pathutils_is_in_path aws_completer
	then
		complete -C aws_completer aws
		return 0
	else
		return 1
	fi
}

register_interactive configure_bash_completions_aws

function configure_bash_completions_aws() {
	local -n __var=$1
	# completions for aws (must have 'awscli' package from ubuntu
	# or python module installed)
	if pathutils_is_in_path aws_completer
	then
		complete -C aws_completer aws
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_bash_completions_aws

function configure_bash_completions_system() {
	local -n __var=$1
	if [ -r /usr/share/bash-completion/bash_completion ]
	then
		_bashy_before_thirdparty
		source /usr/share/bash-completion/bash_completion
		_bashy_after_thirdparty
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_bash_completions_system

function configure_bash_completions_system() {
	local -n __var=$1
	local -n __error=$2
	FILE="/usr/share/bash-completion/bash_completion"
	if [ ! -r "$FILE" ]
	then
		__error="[$FILE] does not exist"
		__var=1
		return
	fi
	_bashy_before_thirdparty
	source /usr/share/bash-completion/bash_completion
	_bashy_after_thirdparty
	__var=0
}

register_interactive configure_bash_completions_system

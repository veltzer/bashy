function configure_bash() {
	local -n __var=$1
	local -n __error=$2
	# history stuff. See https://linuxhint.com/bash_command_history_usage
	HISTSIZE=10000
	HISTFILESIZE=50000
	shopt -s histappend
	__var=0
}

register_interactive configure_bash

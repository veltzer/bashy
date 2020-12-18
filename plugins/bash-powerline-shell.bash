function configure_bash_powerline_shell() {
	local -n __var=$1
	BASH_POWERLINE="$HOME/install/bash-powerline-shell/ps1_prompt"
	if [ -r "$BASH_POWERLINE" ]
	then
		# shellcheck source=/dev/null
		source "$BASH_POWERLINE"
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_bash_powerline_shell

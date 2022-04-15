function _update_ps1() {
	PS1=$(powerline-shell $?)
}

function configure_bash_powerline_shell() {
	local -n __var=$1
	if ! command -v powerline-shell &> /dev/null
	then
		echo "could not find powerline-shell, please install"
		__var=1
		return
	fi
	if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]
	then
		PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
	fi
	__var=0
}

function install_powerline_shell() {
	pip install powerline-shell
}

register_interactive configure_bash_powerline_shell

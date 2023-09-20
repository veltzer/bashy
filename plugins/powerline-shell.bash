# plugin for https://github.com/b-ryan/powerline-shell
# you install it with pip
# I found this to be the best of all the powerlines

function _update_ps1() {
	# PS1=$(powerline-shell $?)
	PS1=$("${POWERLINE_SHELL}" $?)
}

function _activate_powerline_shell() {
	local -n __var=$1
	local -n __error=$2
	if ! command -v powerline-shell &> /dev/null
	then
		__error="[powerline-shell] is not in path"
		__var=1
		return
	fi
	POWERLINE_SHELL=$(which powerline-shell)
	export POWERLINE_SHELL
	if [[ "${TERM}" != "linux" && ! "${PROMPT_COMMAND}" =~ "_update_ps1" ]]
	then
		PROMPT_COMMAND="_update_ps1; ${PROMPT_COMMAND}"
	fi
	__var=0
}

function _install_powerline_shell() {
	pip install --user powerline-shell
	sudo apt-get install fonts-powerline
}

register_interactive _activate_powerline_shell
register_install _install_powerline_shell

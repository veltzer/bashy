# plugin for pypowerline

function _prompt_pypowerline() {
	PS1=""
	"${PYPOWERLINE}" bash
}

function _activate_pypowerline() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "pypowerline" __var __error; then return; fi
	PYPOWERLINE=$(which "pypowerline")
	export PYPOWERLINE
	PROMPT_COMMAND="_prompt_pypowerline; ${PROMPT_COMMAND}"
	__var=0
}

function _install_pypowerline() {
	pip install --upgrade pypowerline
}

register_interactive _activate_pypowerline
register_install _install_pypowerline

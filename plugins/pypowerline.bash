# plugin for pypowerline

function _update_ps1() {
	PS1=$("${PYPOWERLINE}" bash)
}

function _activate_pypowerline() {
	local -n __var=$1
	local -n __error=$2
	if ! command -v "pypowerline" &> /dev/null
	then
		__error="[pypowerline] is not in path"
		__var=1
		return
	fi
	PYPOWERLINE=$(which pypowerline)
	export PYPOWERLINE
	PROMPT_COMMAND="_update_ps1; ${PROMPT_COMMAND}"
	__var=0
}

function _install_pypowerline() {
	pip install pypowerline
}

register_interactive _activate_pypowerline
register_install _install_pypowerline

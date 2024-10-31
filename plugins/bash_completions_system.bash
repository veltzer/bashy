function _activate_bash_completions_system() {
	local -n __var=$1
	local -n __error=$2
	FILE1="/usr/share/bash-completion/bash_completion"
	if ! checkReadableFile "${FILE1}" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source "${FILE1}"
	then
		__var=$?
		__error="could not source [${FILE1}]"
		return
	fi
	FILE2="/etc/bash_completion"
	if ! checkReadableFile "${FILE2}" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source "${FILE2}"
	then
		__var=$?
		__error="could not source [${FILE2}]"
		return
	fi
	__var=0
}

register_interactive _activate_bash_completions_system

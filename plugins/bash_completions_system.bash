function _activate_bash_completions_system() {
	local -n __var=$1
	local -n __error=$2
	FILE1="/usr/share/bash-completion/bash_completion"
	FILE2="/etc/bash_completion"
	if ! checkReadableFile "${FILE1}" __var __error; then return; fi
	if ! checkReadableFile "${FILE2}" __var __error; then return; fi
	_bashy_before_thirdparty
	# shellcheck source=/dev/null
	source "${FILE1}"
	# shellcheck source=/dev/null
	source "${FILE2}"
	_bashy_after_thirdparty
	__var=0
}

register_interactive _activate_bash_completions_system

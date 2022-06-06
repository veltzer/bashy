function _activate_bash_completions_system() {
	local -n __var=$1
	local -n __error=$2
	FILE="/usr/share/bash-completion/bash_completion"
	if ! checkReadableFile "$FILE" __var __error; then return; fi
	_bashy_before_thirdparty
	source /usr/share/bash-completion/bash_completion
	_bashy_after_thirdparty
	__var=0
}

register_interactive _activate_bash_completions_system

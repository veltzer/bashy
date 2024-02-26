function _activate_system_default_bashrc() {
	local -n __var=$1
	local -n __error=$2
	# This script sources the systems default .bashrc.
	BASHRC="/etc/bash.bashrc"
	if ! checkReadableFile "${BASHRC}" __var __error; then return; fi
	# shellcheck disable=1090
	if ! source "${BASHRC}"
	then
		__var=$?
		__error="could not source [${BASHRC}]"
		return
	fi
	__var=0
}

register _activate_system_default_bashrc

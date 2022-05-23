function configure_system_default_bashrc() {
	local -n __var=$1
	local -n __error=$2
	# This script sources the systems default .bashrc.
	BASHRC="/etc/bash.bashrc"
	if ! checkReadableFile "$BASHRC" __var __error; then return; fi
	_bashy_before_thirdparty
	# shellcheck disable=1090
	source "$BASHRC"
	_bashy_after_thirdparty
	__var=0
}

register configure_system_default_bashrc

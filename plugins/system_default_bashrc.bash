function configure_system_default_bashrc() {
	local -n __var=$1
	local -n __error=$2
	# This script sources the systems default .bashrc.
	BASHRC="/etc/bash.bashrc"
	if [ ! -f "$BASHRC" ]
	then
		__error="[$BASHRC] doesnt exist"
		__var=1
		return
	fi
	_bashy_before_thirdparty
	source "$BASHRC"
	_bashy_after_thirdparty
	__var=0
}

register configure_system_default_bashrc

function configure_system_default_bashrc() {
	local -n __var=$1
	# This script sources the systems default .bashrc.
	if [ -f /etc/bash.bashrc ]
	then
		_bashy_before_thirdparty
		source /etc/bash.bashrc
		_bashy_after_thirdparty
		__var=0
		return
	fi
	__var=1
}

register configure_system_default_bashrc

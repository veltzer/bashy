function configure_system_default_bashrc() {
	local __user_var=$1
	# This script sources the systems default .bashrc.
	if [ -f /etc/bash.bashrc ]
	then
		_bashy_before_thirdparty
		source /etc/bash.bashrc
		_bashy_after_thirdparty
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_system_default_bashrc

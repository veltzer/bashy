function configure_powerline() {
	local __user_var=$1
	if [ -x /usr/bin/powerline-daemon ]
	then
		/usr/bin/powerline-daemon -q
		POWERLINE_BASH_CONTINUATION=1
		POWERLINE_BASH_SELECT=1
		_bashy_before_thirdparty
		source /usr/share/powerline/bindings/bash/powerline.sh
		_bashy_after_thirdparty
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_powerline

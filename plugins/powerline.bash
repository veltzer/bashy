function configure_powerline() {
	local __user_var=$1
	# powerline
	found=false
	# we prefer powerline for python3
	if [[ -f /usr/local/bin/powerline-daemon && -f /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh ]]
	then
		export POWERLINE_HOME=/usr/local/lib/python3.5/dist-packages/powerline
		POWERLINE_DAEMON=/usr/local/bin/powerline-daemon
		POWERLINE_SH=/usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh
		found=true
	elif [[ -f /usr/bin/powerline-daemon && -f /usr/share/powerline/bindings/bash/powerline.sh ]]
	then
		export POWERLINE_HOME=/usr/share/powerline
		POWERLINE_DAEMON=/usr/bin/powerline-daemon
		POWERLINE_SH=/usr/share/powerline/bindings/bash/powerline.sh
		found=true
	elif [[ -f /usr/local/bin/powerline-daemon && -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]]
	then
		export POWERLINE_HOME=/usr/local/lib/python2.7/dist-packages/powerline
		POWERLINE_DAEMON=/usr/local/bin/powerline-daemon
		POWERLINE_SH=/usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
		found=true
	fi
	if $found
	then
		POWERLINE_BASH_CONTINUATION=1
		POWERLINE_BASH_SELECT=1
		# the daemon and script may have has warnings or errors
		# and that is why we surround their code with 'bashy_before_thirdparty', 'bashy_after_thirdparty'
		bashy_before_thirdparty
		$POWERLINE_DAEMON -q
		source $POWERLINE_SH
		bashy_after_thirdparty
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_powerline

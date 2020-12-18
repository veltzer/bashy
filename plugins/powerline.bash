function configure_powerline() {
	local -n __var=$1
	if [ -x /usr/bin/powerline-daemon ]
	then
		/usr/bin/powerline-daemon -q
		export POWERLINE_BASH_CONTINUATION=1
		export POWERLINE_BASH_SELECT=1
		_bashy_before_thirdparty
		# shellcheck source=/dev/null
		source /usr/share/powerline/bindings/bash/powerline.sh
		_bashy_after_thirdparty
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_powerline

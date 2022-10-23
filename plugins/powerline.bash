function _activate_powerline() {
	local -n __var=$1
	local -n __error=$2
	EXECUTABLE="/usr/bin/powerline-daemon"
	if [ ! -x "$EXECUTABLE" ]
	then
		__error="[$EXECUTABLE] doesnt exist"
		__var=1
		return
	fi
	/usr/bin/powerline-daemon -q
	export POWERLINE_BASH_CONTINUATION=1
	export POWERLINE_BASH_SELECT=1
	_bashy_before_thirdparty
	# shellcheck source=/dev/null
	source /usr/share/powerline/bindings/bash/powerline.sh
	_bashy_after_thirdparty
	__var=0
}

function _install_powerline() {
	sudo apt update && sudo apt install powerline fonts-powerline
}

register_interactive _activate_powerline

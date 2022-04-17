# This will run screen at the end of interactive logins.
# We avoid the recursion not by looking at the 'TERM' environment
# variable which seems now days not to be set to 'screen' by screen(1)
# but rather by exporting a variable of our own.
#
# You can install screen using:
# 	$ sudo apt-get install screen
#
# References:
# http://askubuntu.com/questions/675139/how-can-i-start-linux-screen-automatically-when-i-open-a-new-terminal-window
# https://pascal.nextrem.ch/2010/04/30/automatically-start-screen-on-ssh-login

function configure_screen() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path screen
	then
		__error="[screen] is not in PATH"
		__var=1
		return
	fi
	if [[ -z ${SCREEN+x} ]]
	then
		export SCREEN=yes
		# shellcheck disable=SC2093
		exec screen -q -RR
	fi
	__var=0
}

register_interactive configure_screen

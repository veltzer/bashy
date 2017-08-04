<<'COMMENT'

This will run screen at the end of interactive logins.
We avoid the recursion not by looking at the 'TERM' environment
variable which seems now days not to be set to 'screen' by screen(1)
but rather by exporting a variable of our own.

You can install screen using:
	$ sudo apt-get install screen

References:
http://askubuntu.com/questions/675139/how-can-i-start-linux-screen-automatically-when-i-open-a-new-terminal-window
https://pascal.nextrem.ch/2010/04/30/automatically-start-screen-on-ssh-login

COMMENT

function configure_screen() {
	if pathutils_is_in_path screen; then
		if [[ -z ${SCREEN+x} ]]; then
			export SCREEN=yes
			exec screen -q -RR
			return 0
		else
			return 0
		fi
	else
		return 1
	fi
}

register_interactive configure_screen

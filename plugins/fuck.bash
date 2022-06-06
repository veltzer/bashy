function _activate_fuck() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath thefuck __var __error; then return; fi
	eval "$(thefuck --alias)"
	__var=0
}

function install_fuck() {
	sudo pip3 install thefuck
}

register_interactive _activate_fuck

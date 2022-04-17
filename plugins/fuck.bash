function configure_fuck() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path thefuck
	then
		__error="[thefuck] is not in PATH"
		__var=1
		return
	fi
	eval "$(thefuck --alias)"
	__var=0
}

function install_fuck() {
	sudo pip3 install thefuck
}

register_interactive configure_fuck

function configure_fuck() {
	local -n __var=$1
	if pathutils_is_in_path thefuck
	then
		eval "$(thefuck --alias)"
		__var=0
		return
	fi
	__var=1
}

function install_fuck() {
	if pathutils_is_in_path pip3
	then
		sudo pip3 install thefuck
	fi
}

register_interactive configure_fuck

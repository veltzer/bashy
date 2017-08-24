function configure_fuck() {
	if pathutils_is_in_path thefuck
	then
		eval $(thefuck --alias)
		result=0
	else
		result=1
	fi
}

function install_fuck() {
	if pathutils_is_in_path pip3
	then
		sudo pip3 install thefuck
	fi
}

register_interactive configure_fuck

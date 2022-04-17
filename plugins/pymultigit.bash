function configure_pymultigit() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path pymultigit
	then
		__error="[pymultigit] is not in PATH"
		__var=1
		return
	fi
	alias mg=pymultigit
	__var=0
}

register_interactive configure_pymultigit

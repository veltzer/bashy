function configure_pymultigit() {
	local -n __var=$1
	# these are aliases for pymultigit
	alias mg=pymultigit
	__var=0
}

register_interactive configure_pymultigit

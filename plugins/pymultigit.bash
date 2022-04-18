function configure_pymultigit() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath pymultigit __var __error; then return; fi
	alias mg=pymultigit
	__var=0
}

register_interactive configure_pymultigit

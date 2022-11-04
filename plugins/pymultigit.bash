# this plugin is really just an alias
# the alias should move to ~/.bashy_extra/aliases and this plugin should cease to exist

function _activate_pymultigit() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath pymultigit __var __error; then return; fi
	alias mg=pymultigit
	__var=0
}

register_interactive _activate_pymultigit

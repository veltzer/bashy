# This is a plugin for pass(1), the standard unix password manager.
# It configures nothing yet; it only reports whether pass is installed.

function _activate_pass() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "pass" __var __error; then return; fi
	__var=0
}

register_interactive _activate_pass

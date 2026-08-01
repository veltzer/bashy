# This is a plugin for pass(1), the standard unix password manager.
# It points pass at a store kept in the dots repository instead of the
# default ~/.password-store.

function _activate_pass() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "pass" __var __error; then return; fi
	export PASSWORD_STORE_DIR="${HOME}/git/dots/password-store"
	__var=0
}

register_interactive _activate_pass

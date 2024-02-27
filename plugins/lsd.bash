function _activate_lsd() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "lsd" __var __error; then return; fi
	alias ls="lsd"
	__var=0
}

register_interactive _activate_lsd

function _activate_git() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "git" __var __error; then return; fi
	__var=0
}

register_interactive _activate_git

function _activate_pip() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "pip" __var __error; then return; fi
	bashy_completion pip pip completion --bash
	__var=0
}

register _activate_pip

# This is integration of gh, the github command line tool
function _activate_gh() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath gh __var __error; then return; fi
	eval "$(gh completion -s bash)"
	__var=0
}

register_interactive _activate_gh

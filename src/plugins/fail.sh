function _activate_fail() {
	local -n __var=$1
	local -n __error=$2
	__error="generic error message from _activate_fail"
	__var=1
}

register _activate_fail

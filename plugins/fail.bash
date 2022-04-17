function configure_fail() {
	local -n __var=$1
	local -n __error=$1
	__error="generic error message from configure_fail"
	__var=1
}

register configure_fail

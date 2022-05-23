function configure_pip() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath pip __var __error; then return; fi
	# shellcheck disable=1090
	source <(pip completion --bash)
	__var=0
}

register configure_pip

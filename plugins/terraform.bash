function _activate_terraform() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath terraform __var __error; then return; fi
	complete -C /usr/bin/terraform terraform
	__var=0
}

function _install_terraform() {
	# TBD
	:
}

register_interactive _activate_terraform

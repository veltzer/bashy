# https://starship.rs/

function _activate_starship() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "starship" __var __error; then return; fi
	eval "$(starship init bash)"
	__var=0
}

function _install_starship() {
	:
}

register_interactive _activate_starship
register_install _install_starship

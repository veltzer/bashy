function _activate_zoxide() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "zoxide" __var __error; then return; fi
	if ! checkInPath "fzf" __var __error; then return; fi
	eval "$(zoxide init bash)"
	alias cd="z"
	__var=0
}

function _install_zoxide() {
	sudo apt install zoxide
}

register_interactive _activate_zoxide

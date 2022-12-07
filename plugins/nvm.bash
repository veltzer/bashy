# This is nvm integration 
function _activate_nvm() {
	local -n __var=$1
	local -n __error=$2
	NVM_DIR="$HOME/.nvm"
	if ! checkReadableFile "$NVM_DIR/nvm.sh" __var __error; then return; fi
	if ! checkReadableFile "$NVM_DIR/bash_completion" __var __error; then return; fi
	_bashy_before_thirdparty
	# shellcheck source=/dev/null
	source "$NVM_DIR/nvm.sh"
	# shellcheck source=/dev/null
	source "$NVM_DIR/bash_completion"
	_bashy_after_thirdparty
	__var=0
}

function _install_nvm() {
	# TBD
	:
}

register_interactive _activate_nvm

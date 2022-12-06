# This is nvm integration 
function _activate_nvm() {
	local -n __var=$1
	local -n __error=$2
	NVM_DIR="$HOME/.nvm"
	if [ -r "$NVM_DIR/nvm.sh" ]
	then
		_bashy_before_thirdparty
		source "$NVM_DIR/nvm.sh"
		_bashy_after_thirdparty
	fi
	if [ -r "$NVM_DIR/bash_completion" ]
	then
		_bashy_before_thirdparty
		source "$NVM_DIR/bash_completion"
		_bashy_after_thirdparty
	fi
	export NVM_DIR
	__var=0
}

function _install_nvm() {
	# TBD
	:
}

register_interactive _activate_nvm

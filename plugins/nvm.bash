# This is nvm integration 
function _activate_nvm() {
	local -n __var=$1
	local -n __error=$2
	NVM_DIR="$HOME/.nvm"
	if [ -s "$NVM_DIR/nvm.sh" ]
	then
		"$NVM_DIR/nvm.sh"
	fi
	if [ -s "$NVM_DIR/bash_completion" ]
	then
		"$NVM_DIR/bash_completion"
	fi
	export NVM_DIR
}

function _install_nvm() {
	# TBD
	:
}

register_interactive _activate_nvm

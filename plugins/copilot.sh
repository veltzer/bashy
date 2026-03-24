function _activate_copilot() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function _install_copilot() {
	before_strict
	npm install -g "@google/copilot-cli"
	after_strict
}

register _activate_copilot

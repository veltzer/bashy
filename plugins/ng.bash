# This is integration of angular.js (ng on the command line)
function _activate_ng() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath ng __var __error; then return; fi
	# shellcheck source=/dev/null
	source <(ng completion script)
	__var=0
}

function _install_ng() {
	npm install -g @angular/cli
}

register_interactive _activate_ng

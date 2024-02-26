# This is integration of angular.js (ng on the command line)
function _activate_ng() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "ng" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(ng completion script)
	then
		__var=$?
		__error="could not source ng completion script"
	fi
	__var=0
}

function _install_ng() {
	npm install -g @angular/cli
}

register_interactive _activate_ng

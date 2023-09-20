# this plugin helps you activate a customized virtual env

function _activate_venv() {
	local -n __var=$1
	local -n __error=$2
	if ! var_is_defined VENV
	then
		__error="VENV is not defined"
		__var=1
		return
	fi
	if ! checkDirectoryExists "${VENV}" __var __error; then return; fi
	# activate the virtual envrionment
	# shellcheck source=/dev/null
	source "${VENV}/bin/activate"
	__var=0
}

register_interactive _activate_venv

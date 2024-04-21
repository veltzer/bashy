# this plugin helps you activate a customized virtual env

function _activate_python_venv() {
	local -n __var=$1
	local -n __error=$2
	if ! var_is_defined PYTHON_VENV
	then
		__error="PYTHON_VENV is not defined"
		__var=1
		return
	fi
	if ! checkDirectoryExists "${PYTHON_VENV}" __var __error; then return; fi
	# activate the virtual envrionment
	# shellcheck source=/dev/null
	if ! source "${PYTHON_VENV}/bin/activate"
	then
		__var=$?
		__error="could not activate virtual env"
		return
	fi
	__var=0
}

register_interactive _activate_python_venv

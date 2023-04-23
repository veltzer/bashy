# this plugin helps you activate a local virtual env

function _activate_local_venv() {
	local -n __var=$1
	local -n __error=$2
	if ! var_is_defined LOCAL_VENV 
	then
		__error="LOCAL_VENV is not defined"
		__var=1
		return
	fi
	if ! checkDirectoryExists "${LOCAL_VENV}" __var __error; then return; fi
	# activate the virtual envrionment
	# shellcheck source=/dev/null
	source "${LOCAL_VENV}/bin/activate"
	__var=0
}

register _activate_local_venv

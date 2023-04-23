# This plugin allows you to use your own folder (say "${HOME}/install/python")
# for storing modules which are not well packaged and distributed yet.
#
# If you do packages all of your python modules correctly then you don't
# need this module since you can install your modules regularly either
# at the system level or at the user level.

function _activate_local_python() {
	local -n __var=$1
	local -n __error=$2
	if ! var_is_defined PYTHON_LOCAL
	then
		__error="PYTHON_LOCAL is not defined"
		__var=1
		return
	fi
	if ! checkDirectoryExists "${PYTHON_LOCAL}" __var __error; then return; fi
	pathutils_add_head PYTHONPATH "${PYTHON_LOCAL}/bin"
	__var=0
}

register _activate_local_python

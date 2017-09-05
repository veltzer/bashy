function configure_python() {
	local __user_var=$1
	# this script adjusts PYTHONPATH to find
	# packages that we installed using PIP and PIP3
	# into the users home directory using pip flag --user.

	# strictly speaking this is not needed in modern python implementations
	# which already take module from the user site

	# add user base to python path
	# pathutils_add_head PYTHONPATH "`python -c \"import site; print site.USER_SITE;\"`"
	export PYTHONIOENCODING=UTF-8
	var_set_by_name "$__user_var" 0
}

function prun() {
	# this function run a python module using python2 by its filename
	# remove .py
	module=${1:0:-3}
	# replace slashes by dots
	module=${module//\//.}
	python -m $module ${@:2}
}

register configure_python

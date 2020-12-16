function configure_python() {
	local -n __var=$1
	# this script adjusts PYTHONPATH to find
	# packages that we installed using PIP and PIP3
	# into the users home directory using pip flag --user.

	# strictly speaking this is not needed in modern python implementations
	# which already take module from the user site

	# add user base to python path
	# pathutils_add_head PYTHONPATH "`python -c \"import site; print site.USER_SITE;\"`"

	# this sets up python encoding to utf. This is needed for python2.7 only and even
	# for it I think it is not needed for new versions of 2.7 (need to check).
	export PYTHONIOENCODING=UTF-8

	# setup where you have pycharm installed (if you have it).
	export PYCHARM_HOME="${HOME}/install/pycharm"
	__var=0
}

function pyrun() {
	# this function run a python module using python -m by its filename
	# why do you need this? python -m does not auto complete python modules
	# while file names are auto completed by the shell...
	# this is very convenient

	# TODO:
	# - if the path given is absolute then give an error or deduce where it starts.

	if [[ $# == 0 ]]
	then
		echo "pyrun: error: usage: pyrun [relative_path]"
		return
	fi

	# remove .py
	module=${1%.py}
	# replace slashes by dots
	module=${module//\//.}
	# trailing slash / dot
	module=${module%.}
	python -m "$module" "${@:2}"
}

register configure_python

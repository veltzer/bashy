# This plugin helps with various python related issues
#
# What does it provide?
# - configuring the python keyring so it would work.
# - the pyrun command to run python code with good auto-comletion.

function _activate_python() {
	local -n __var=$1
	local -n __error=$2
	export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
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
	# remove ./ if exists
	module=${module#\./}
	# replace slashes by dots
	module=${module//\//.}
	# trailing slash / dot
	module=${module%.}
	python -m "$module" "${@:2}"
}

register _activate_python

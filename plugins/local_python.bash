function configure_local_python() {
	local -n __var=$1
	local -n __error=$2
	export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
	if ! var_is_defined PYTHON_LOCAL
	then
		__error="PYTHON_LOCAL is not defined"
		__var=1
		return
	fi
	if [ ! -d "$PYTHON_LOCAL" ]
	then
		__error="PYTHON_LOCAL is defined but is not a valid directory"
		__var=1
		return
	fi
	pathutils_add_tail PYTHONPATH "$PYTHON_LOCAL"
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

register configure_local_python

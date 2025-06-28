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
	# this function runs a python module using python -m by its filename
	# why do you need this? python -m does not auto complete python modules
	# while file names are auto completed by the shell...
	# this is very convenient

	# A helper function to run Python modules from a file path,
	# automatically handling both flat and 'src' project layouts.
	#
	# Usage:
	#   For a flat layout: pyrun my_module/main.py
	#   For an src layout:  pyrun src/my_module/main.py
	#
	# Check if any arguments were provided.
	if [[ ${#} == 0 ]]
	then
		echo "pyrun: error: usage: pyrun [relative_path]";
		return 1;
	fi;

	local module_path=$1
	local module

	# Check if the provided path is absolute. This function requires a relative path.
	if [[ "${module_path}" == /* ]]
	then
		echo "pyrun: error: please provide a relative path, not an absolute one.";
		return 1;
	fi;

	# Remove the leading './' if it exists.
	module_path=${module_path#\./};

	# If the path starts with 'src/', remove it for the module name calculation.
	# This ensures that 'src/my_package/main.py' becomes 'my_package.main'.
	if [[ "${module_path}" == src/* ]]
	then
		module=${module_path#src/};
	else
		module=${module_path};
	fi

	# Convert the file path to a Python module path.
	# Example: 'my_package/main.py' becomes 'my_package.main'
	module=${module%.py};      # Remove .py extension
	module=${module//\//.};    # Replace all '/' with '.'
	module=${module%.};        # Remove trailing '.' if any

	# Check for the existence of an 'src' directory.
	if [[ -d "src" ]]
	then
		# If 'src' exists, run the command with PYTHONPATH set to 'src'.
		# This allows Python to find the modules inside the src directory.
		# echo "--> Found 'src' directory. Running with PYTHONPATH=src"
		PYTHONPATH="src" python -m "${module}" "${@:2}"
	else
		# If no 'src' directory, run the command normally for a flat layout.
		python -m "${module}" "${@:2}"
	fi
}

register _activate_python

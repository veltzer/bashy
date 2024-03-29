# These are utility functions regarding the python programming
# language

# A function that returns the short version of the python interpreter
function python_version_short() {
	local __user_var=$1
	local python=$2
	local version
	version=$("${python}" --version 2>&1)
	# retain only what is after the last space (Python 3.5.3 -> 3.5.3)
	version="${version##* }"
	# retain only what is before the last dot (3.5.3 -> 3.5)
	version="${version%.*}"
	eval "${__user_var}=\"${version}\""
}

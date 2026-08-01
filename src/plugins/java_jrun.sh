# This plugin defines jrun, a command to easily run java main classes for you

function jrun() {
	# this function run a java main class for you
	# why do you need this?
	# because writing the full command line to run java is tedius.

	# TODO:
	# - if the path given is absolute then give an error or deduce where it starts.

	if [[ ${#} == 0 ]]
	then
		echo "jrun: error: usage: jrun [relative_path]"
		return
	fi

	# remove .java
	module=${1%.java}
	# remove ./ if exists
	module=${module#\./}
	# remove first src/
	module=${module#src/}
	# replace slashes by dots
	module=${module//\//.}
	# remove trailing slash / dot
	module=${module%.}
	java -classpath out "${module}" "${@:2}"
	# echo "${module}"
}

function _activate_java_jrun() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register _activate_java_jrun

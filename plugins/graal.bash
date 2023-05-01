function _activate_graal() {
	local -n __var=$1
	local -n __error=$2
	JAVA_HOME="${HOME}/install/graalvm"
	if ! checkDirectoryExists "${JAVA_HOME}" __var __error; then return; fi
	export JAVA_HOME
	pathutils_add_head PATH "${JAVA_HOME}/bin"
	pathutils_add_head LD_LIBRARY_PATH "${JAVA_HOME}/lib"
	__var=0
}

register _activate_graal

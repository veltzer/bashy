function _activate_java() {
	local -n __var=$1
	local -n __error=$2
	JAVA_HOME="${HOME}/install/jdk"
	if ! checkDirectoryExists "${JAVA_HOME}" __var __error; then return; fi
	export JAVA_HOME
	_bashy_pathutils_add_head PATH "${JAVA_HOME}/bin"
	_bashy_pathutils_add_head LD_LIBRARY_PATH "${JAVA_HOME}/lib"
	__var=0
}

register _activate_java

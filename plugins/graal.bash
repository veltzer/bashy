function configure_graal() {
	local -n __var=$1
	JAVA_HOME="$HOME/install/graalvm"
	if [ -d "$JAVA_HOME" ]
	then
		export JAVA_HOME
		pathutils_add_head PATH "${JAVA_HOME}/bin"
		pathutils_add_head LD_LIBRARY_PATH "${JAVA_HOME}/lib"
		__var=0
		return
	fi
	__var=1
}

register configure_graal

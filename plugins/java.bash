function configure_java() {
	local -n __var=$1
	JAVA_HOME="$HOME/install/java"
	if [ -d "$JAVA_HOME" ]
	then
		pathutils_add_head PYTHONPATH "${JAVA_HOME}/bin"
		pathutils_add_head LD_LIBRARY_PATH "${JAVA_HOME}/lib"
		export JAVA_HOME
		__var=0
		return
	fi
	__var=1
}

register configure_java

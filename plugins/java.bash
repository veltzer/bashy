function configure_java() {
	local -n __var=$1
	local -n __error=$2
	JAVA_HOME="$HOME/install/jdk"
	if [ ! -d "$JAVA_HOME" ]
	then
		__error="[$JAVA_HOME] doesnt exist"
		__var=1
		return
	fi
	export JAVA_HOME
	pathutils_add_head PATH "${JAVA_HOME}/bin"
	pathutils_add_head LD_LIBRARY_PATH "${JAVA_HOME}/lib"
	__var=0
}

register configure_java

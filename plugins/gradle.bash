function configure_gradle() {
	local -n __var=$1
	local -n __error=$2
	GRADLE_HOME="${HOME}/install/gradle"
	if [ ! -d "${GRADLE_HOME}" ]
	then
		__error="[$GRADLE_HOME] doesnt exist"
		__var=1
		return
	fi
	export GRADLE_HOME
	pathutils_add_head PATH "${GRADLE_HOME}/bin"
	__var=0
}

register configure_gradle

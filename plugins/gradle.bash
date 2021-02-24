function configure_gradle() {
	local -n __var=$1
	GRADLE_HOME="${HOME}/install/gradle"
	if [ -d "${GRADLE_HOME}" ]
	then
		export GRADLE_HOME
		pathutils_add_head PATH "${GRADLE_HOME}/bin"
		__var=0
		return
	fi
	__var=1
}

register configure_gradle

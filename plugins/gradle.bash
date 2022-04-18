function configure_gradle() {
	local -n __var=$1
	local -n __error=$2
	GRADLE_HOME="${HOME}/install/gradle"
	if ! checkDirectoryExists "$GRADLE_HOME" __var __error; then return; fi
	export GRADLE_HOME
	pathutils_add_head PATH "${GRADLE_HOME}/bin"
	__var=0
}

register configure_gradle

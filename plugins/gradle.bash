function _activate_gradle() {
	local -n __var=$1
	local -n __error=$2
	GRADLE_HOME="${HOME}/install/gradle"
	if ! checkDirectoryExists "${GRADLE_HOME}" __var __error; then return; fi
	export GRADLE_HOME
	pathutils_add_head PATH "${GRADLE_HOME}/bin"
	__var=0
}

function _install_gradle() {
	# this function installs gradle from a binary zip file distribution
	version="8.2.1"
	folder="gradle-${version}"
	filename="${folder}-bin.zip"
	rm -rf "/tmp/${filename}" "/tmp/${folder}"
	wget "https://downloads.gradle.org/distributions/${filename}" -P /tmp
	unzip -qq "/tmp/${filename}" -d "${HOME}/install"
}

function _install_gradle_apt() {
	sudo apt install gradle
}

register _activate_gradle

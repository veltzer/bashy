function _activate_gradle() {
	local -n __var=$1
	local -n __error=$2
	GRADLE_HOME="${HOME}/install/gradle"
	if ! checkDirectoryExists "${GRADLE_HOME}" __var __error; then return; fi
	export GRADLE_HOME
	_bashy_pathutils_add_head PATH "${GRADLE_HOME}/bin"
	__var=0
}

function _install_gradle() {
	# this function installs gradle from a binary zip file distribution
	version="8.14.1"
	folder="gradle-${version}"
	filename="${folder}-bin.zip"
	rm -rf "/tmp/${filename}"
	rm -rf "${HOME}/install/${folder}" "${HOME}/install/gradle"
	wget "https://downloads.gradle.org/distributions/${filename}" -P /tmp
	unzip -qq "/tmp/${filename}" -d "${HOME}/install"
	cd "${HOME}/install" || return
	ln -s "${folder}" "gradle"
}

function _install_gradle_apt() {
	sudo apt install gradle
}

register _activate_gradle

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
	# this function installs the latest gradle from a binary zip file distribution
	version=$(curl -fsSL https://services.gradle.org/versions/current | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])")
	if [ -z "${version}" ]; then
		echo "Could not determine latest Gradle version"
		return 1
	fi
	folder="gradle-${version}"
	filename="${folder}-bin.zip"
	installed=""
	if [ -x "${HOME}/install/gradle/bin/gradle" ]
	then
		installed=$("${HOME}/install/gradle/bin/gradle" --version 2>/dev/null | awk '/^Gradle /{print $2; exit}')
	fi
	if bashy_install_check "gradle" "${installed}" "${version}"
	then
		return
	fi
	rm -rf "${HOME}/install/${folder}" "${HOME}/install/gradle"
	local archive
	bashy_download "https://downloads.gradle.org/distributions/${filename}" archive || return
	unzip -qq "${archive}" -d "${HOME}/install"
	cd "${HOME}/install" || return
	ln -s "${folder}" "gradle"
}

function _install_gradle_apt() {
	sudo apt install gradle
}

register _activate_gradle

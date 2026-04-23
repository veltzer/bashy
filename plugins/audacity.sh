# this is a plugin for audacity. Mostly it installs audacity.

function _activate_audacity() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "audacity" __var __error; then return; fi
	__var=0
}

function _install_audacity() {
	before_strict
	version="3.4.2"
	folder="${HOME}/install/binaries"
	executable="${folder}/audacity"
	marker="${folder}/.audacity_version"
	if [ -x "${executable}" ] && [ -f "${marker}" ] && [ "$(cat "${marker}")" = "${version}" ]; then
		echo "audacity ${version} is already installed"
		after_strict
		return
	fi
	_uninstall_audacity
	url="https://github.com/audacity/audacity/releases/download/Audacity-${version}/audacity-linux-${version}-x64.AppImage"
	curl --fail --location --silent --output "${executable}" "${url}"
	chmod +x "${executable}"
	echo "${version}" > "${marker}"
	echo "downloaded ${executable}"
	after_strict
}

function _uninstall_audacity() {
	before_strict
	folder="${HOME}/install/binaries"
	executable="${folder}/audacity"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no audacity detected"
	fi
	after_strict
}

register _activate_audacity

# this is a plugin for audacity. Mostly it installs audacity.

function _activate_audacity() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "audacity" __var __error; then return; fi
	__var=0
}

function _install_audacity() {
	set +e
	_uninstall_audacity
	folder="${HOME}/install/binaries"
	executable="${folder}/audacity"
	url="https://github.com/audacity/audacity/releases/download/Audacity-3.4.2/audacity-linux-3.4.2-x64.AppImage"
	curl --location --silent --output "${executable}" "${url}"
	chmod +x "${executable}"
	echo "downloaded ${executable}"
	set -e
}

function _uninstall_audacity() {
	set +e
	folder="${HOME}/install/binaries"
	executable="${folder}/audacity"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no audacity detected"
	fi
	set -e
}

register _activate_audacity

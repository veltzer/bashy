# this is a plugin for audacity. Mostly it installs audacity.

function _activate_audacity() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "audacity" __var __error; then return; fi
	__var=0
}

function _install_audacity() {
	before_strict
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/audacity/audacity/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^Audacity-//')
	folder="${HOME}/install/binaries"
	executable="${folder}/audacity"
	# the AppImage cannot report its own version ("audacity --version" just dumps
	# library paths), so record what we installed in a marker file next to it.
	marker="${folder}/.audacity_version"
	if [ -x "${executable}" ] && [ -f "${marker}" ]; then
		installed_version=$(cat "${marker}")
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "audacity ${latest_version} is already installed (latest)"
			after_strict
			return
		fi
		echo "audacity ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing audacity ${latest_version}"
	fi
	# assets are named audacity-linux-<version>-x64-<ubuntu release>.AppImage, take the newest base
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(test("audacity-linux-.*-x64.*\\.AppImage$"))' | sort --version-sort | tail -1)
	if [ -z "${download_file}" ]; then
		echo "ERROR: could not find an audacity linux x64 AppImage in the latest release"
		after_strict
		return 1
	fi
	echo "download_file is [${download_file}]"
	local appimage
	bashy_download "${download_file}" appimage || { after_strict; return 1; }
	rm -f "${executable}" "${marker}"
	cp "${appimage}" "${executable}"
	chmod +x "${executable}"
	echo "${latest_version}" > "${marker}"
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
	rm -f "${folder}/.audacity_version"
	after_strict
}

register _activate_audacity

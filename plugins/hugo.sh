# This is a plugin for hugo

function _activate_hugo() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "hugo" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(hugo completion bash)
	then
		__var=1
		__error="problem in sourcing hugo completion"
		return
	fi
	__var=0
}

function _install_hugo_2() {
	sudo apt install hugo
}

function _install_hugo() {
	# instructions for installing hugo are at https://gohugo.io/installation/linux/
	before_strict
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/gohugoio/hugo/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/binaries"
	executable="${folder}/hugo"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version 2>/dev/null | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "hugo" "${installed_version}" "${latest_version}"
	then
		after_strict
		return
	fi
	# the release also ships a hugo_extended_withdeploy_... build, exclude it so this
	# matches exactly one asset rather than returning two urls
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(test("hugo_extended_[0-9][^/]*_linux-amd64\\.tar\\.gz$"))')
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || { after_strict; return; }
	rm -f "${executable}"
	# --touch so the installed file is stamped now, not with the release build time
	tar xf "${tar}" -m -C "${folder}" hugo
	after_strict
}

function _uninstall_hugo() {
	folder="${HOME}/install/binaries"
	executable="${folder}/hugo"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no hugo detected"
	fi
}

register_interactive _activate_hugo

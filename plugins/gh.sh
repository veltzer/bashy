# This is integration of gh, the github command line tool
function _activate_gh() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "gh" __var __error; then return; fi
	bashy_completion gh gh completion -s bash
	__var=0
}

function _install_gh_apt() {
	sudo apt install gh
}

function _install_gh() {
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/cli/cli/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder=$(bashy_install_dir)
	executable="${folder}/gh"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^gh version/{print $3; exit}')
	fi
	if bashy_install_check "gh" "${installed_version}" "${latest_version}"
	then
		return
	fi
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	checksums=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_checksums.txt"))')
	bashy_verify_sha256 "${tar}" "${checksums}" || return
	rm -f "${executable}"
	# --touch so the installed file is stamped now, not with the release build time
	tar xf "${tar}" -m -C "${folder}" --wildcards "*/bin/gh" --transform 's/.*\/bin\/gh/gh/g'
}

function _uninstall_gh() {
	bashy_uninstall_binary "gh"
}

register_interactive _activate_gh

# this is a plugin for lazygit
# this doesn't really do anything besides provide a function to install lazygit, I really
# need to think about plugins like that.

function _install_lazygit() {
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/jesseduffield/lazygit/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/binaries"
	executable="${folder}/lazygit"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | grep -oP 'version=\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "lazygit" "${installed_version}" "${latest_version}"
	then
		return
	fi
	# upstream renamed these from _Linux_x86_64 to _linux_x86_64, match either
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(test("_[Ll]inux_x86_64\\.tar\\.gz$"))')
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	checksums=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("checksums.txt"))')
	bashy_verify_sha256 "${tar}" "${checksums}" || return
	bashy_install_extract "${tar}" "${folder}" lazygit
}

function _activate_lazygit() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function _uninstall_lazygit() {
	bashy_uninstall_binary "lazygit"
}

register _activate_lazygit
register_install _install_lazygit

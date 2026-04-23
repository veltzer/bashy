# this is a plugin for lazygit
# this doesn't really do anything besides provide a function to install lazygit, I really
# need to think about plugins like that.

function _install_lazygit() {
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/jesseduffield/lazygit/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/binaries"
	executable="${folder}/lazygit"
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" --version 2>/dev/null | grep -oP 'version=\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "lazygit ${latest_version} is already installed (latest)"
			return
		fi
		echo "lazygit ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing lazygit ${latest_version}"
	fi
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_Linux_x86_64.tar.gz"))')
	echo "download_file is ${download_file}"
	tar="/tmp/lazygit.tar.gz"
	rm -f "${tar}"
	curl --fail --location --silent "${download_file}" --output "${tar}"
	tar xf "${tar}" -C "${folder}" lazygit
	rm -f "${tar}"
}

function _activate_lazygit() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register _activate_lazygit
register_install _install_lazygit

# This is integration of gh, the github command line tool
function _activate_gh() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "gh" __var __error; then return; fi
	eval "$(gh completion -s bash)"
	__var=0
}

function _install_gh_apt() {
	sudo apt install gh
}

function _install_gh() {
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/cli/cli/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/binaries"
	executable="${folder}/gh"
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^gh version/{print $3; exit}')
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "gh ${latest_version} is already installed (latest)"
			return
		fi
		echo "gh ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing gh ${latest_version}"
	fi
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	echo "download_file is [${download_file}]. It is the latest version."
	tar="/tmp/gh.tar.gz"
	rm -f "${tar}"
	curl --fail --location --silent "${download_file}" --output "${tar}"
	tar xf "${tar}" -C "${folder}" --wildcards "*/bin/gh" --transform 's/.*\/bin\/gh/gh/g'
	rm -f "${tar}"
}

register_interactive _activate_gh

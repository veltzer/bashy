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
	tar="/tmp/gh.tar.gz"
	rm -f "${tar}"
	download_file=$(curl --fail --silent --location "https://api.github.com/repos/cli/cli/releases/latest" | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	echo "download_file is ${download_file}"
	curl --fail --location --silent "${download_file}" --output "${tar}"
	folder="${HOME}/install/binaries"
	tar xf "${tar}" -C "${folder}" --wildcards "*/bin/gh" --transform 's/.*\/bin\/gh/gh/g' 
	rm -f "${tar}"
	# there is not need to set the "x" bit on the file since tar extracts it with the right bits
	# executable="${folder}/lazygit"
	# chmod +x "${executable}" 
}

register_interactive _activate_gh

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
	set +e
	tar="/tmp/hugo.tar.gz"
	rm -f "${tar}"
	download_file=$(curl --silent --location https://api.github.com/repos/gohugoio/hugo/releases/latest | jq --raw-output '.assets[].browser_download_url | select(test("hugo_extended.*_linux-amd64.tar.gz$"))')
	echo "download_file is [${download_file}]"
	curl --location --silent "${download_file}" --output "${tar}"
	folder="${HOME}/install/binaries"
	tar xf "${tar}" -C "${folder}" hugo
	rm -f "${tar}"
	set -e
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

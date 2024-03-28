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
	set +e
	# instructions for installing hugo are at
	if true
	then
		version=$(curl --silent --location "https://dl.hugo.io/release/stable.txt")
		echo "installing latest version ${version}"
	else
		version="v1.26.7"
		echo "installing hardcoded version ${version}"
	fi
	folder="${HOME}/install/binaries"
	executable="${folder}/hugo"
	curl --location --silent --output "${executable}" "https://dl.hugo.io/release/${version}/bin/linux/amd64/hugo"
	chmod +x "${executable}"
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

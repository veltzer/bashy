function _activate_packer() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "packer" __var __error; then return; fi
	complete -C "packer" packer
	__var=0
}

function _install_packer() {
	before_strict
	# latest version: https://github.com/hashicorp/terraform/issues/9803
	version=$(curl --fail --show-error --silent "https://checkpoint-api.hashicorp.com/v1/check/packer" | jq -r -M ".current_version")
	folder="${HOME}/install/binaries"
	executable="${folder}/packer"
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" --version 2>/dev/null | grep -oP '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
		if [ "${installed_version}" = "${version}" ]; then
			echo "packer ${version} is already installed (latest)"
			after_strict
			return
		fi
		echo "packer ${installed_version} is installed, upgrading to ${version}"
	else
		echo "Installing packer ${version}"
	fi
	file="packer_${version}_linux_amd64.zip"
	url="https://releases.hashicorp.com/packer/${version}/${file}"
	rm -rf "/tmp/${file}" "${folder}/packer"
	wget --quiet "${url}" -P "/tmp"
	unzip -q "/tmp/${file}" -d "${folder}" packer
	rm -f "/tmp/${file}"
	after_strict
}

register_interactive _activate_packer

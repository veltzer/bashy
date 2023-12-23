function _activate_packer() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "packer" __var __error; then return; fi
	complete -C "packer" packer
	__var=0
}

function _install_packer() {
	# latest version: https://github.com/hashicorp/terraform/issues/9803
	version=$(curl -s "https://checkpoint-api.hashicorp.com/v1/check/packer" | jq -r -M ".current_version")
	echo "got version [${version}]..."
	file="packer_${version}_linux_amd64.zip"
	download="https://releases.hashicorp.com/packer/${version}/${file}"
	folder="${HOME}/install/binaries"
	rm -rf "/tmp/${file}" "${folder}/terraform"
	wget "${download}" -P "/tmp"
	unzip "/tmp/${file}" -d "${folder}" 
	rm -rf "/tmp/${file}"
}

register_interactive _activate_packer

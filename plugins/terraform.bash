function _activate_terraform() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "terraform" __var __error; then return; fi
	complete -C "terraform" terraform
	__var=0
}

function _install_terraform() {
	# latest version: https://github.com/hashicorp/terraform/issues/9803
	version=$(curl -s "https://checkpoint-api.hashicorp.com/v1/check/terraform" | jq -r -M ".current_version")
	# version="1.5.5"
	file="terraform_${version}_linux_amd64.zip"
	download="https://releases.hashicorp.com/terraform/${version}/${file}"
	folder="${HOME}/install/binaries"
	rm -rf "/tmp/${file}" "${folder}/terraform"
	wget "${download}" -P "/tmp"
	unzip "/tmp/${file}" -d "${folder}" 
	rm -rf "/tmp/${file}"
}

register_interactive _activate_terraform

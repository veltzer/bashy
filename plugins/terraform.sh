function _activate_terraform() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "terraform" __var __error; then return; fi
	complete -C "terraform" terraform
	__var=0
}

function _install_terraform() {
	before_strict
	# latest version: https://github.com/hashicorp/terraform/issues/9803
	version=$(curl --fail --silent "https://checkpoint-api.hashicorp.com/v1/check/terraform" | jq -r -M ".current_version")
	folder="${HOME}/install/binaries"
	executable="${folder}/terraform"
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" version 2>/dev/null | grep -oP '^Terraform v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
		if [ "${installed_version}" = "${version}" ]; then
			echo "terraform ${version} is already installed (latest)"
			after_strict
			return
		fi
		echo "terraform ${installed_version} is installed, upgrading to ${version}"
	else
		echo "Installing terraform ${version}"
	fi
	file="terraform_${version}_linux_amd64.zip"
	download="https://releases.hashicorp.com/terraform/${version}/${file}"
	rm -rf "/tmp/${file}" "${folder}/terraform"
	wget --quiet "${download}" -P "/tmp"
	unzip -q "/tmp/${file}" -d "${folder}" terraform
	rm -rf "/tmp/${file}"
	after_strict
}

register_interactive _activate_terraform

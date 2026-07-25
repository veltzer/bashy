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
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version 2>/dev/null | grep -oP '^Terraform v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "terraform" "${installed_version}" "${version}"
	then
		after_strict
		return
	fi
	file="terraform_${version}_linux_amd64.zip"
	download="https://releases.hashicorp.com/terraform/${version}/${file}"
	rm -f "${executable}"
	local archive
	bashy_download "${download}" archive || { after_strict; return; }
	unzip -q "${archive}" -d "${folder}" terraform
	# unzip restores the timestamp stored in the zip, stamp it with the install time instead
	touch "${executable}"
	after_strict
}

register_interactive _activate_terraform

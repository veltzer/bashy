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
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | grep -oP '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "packer" "${installed_version}" "${version}"
	then
		after_strict
		return
	fi
	file="packer_${version}_linux_amd64.zip"
	url="https://releases.hashicorp.com/packer/${version}/${file}"
	rm -f "${executable}"
	local archive
	bashy_download "${url}" archive || { after_strict; return; }
	sums="https://releases.hashicorp.com/packer/${version}/packer_${version}_SHA256SUMS"
	bashy_verify_sha256 "${archive}" "${sums}" || { after_strict; return; }
	unzip -q "${archive}" -d "${folder}" packer
	# unzip restores the timestamp stored in the zip, stamp it with the install time instead
	touch "${executable}"
	after_strict
}

function _uninstall_packer() {
	bashy_uninstall_binary "packer"
}

register_interactive _activate_packer

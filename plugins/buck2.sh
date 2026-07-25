# this is a plugin for buck2

function _install_buck2() {
	before_strict
	# buck2 ships from a rolling "latest" tag whose published_at never moves, so the
	# version is the date of the asset itself. "buck2 --version" prints "buck2 <date>-<hash>",
	# so both sides of the comparison end up as a plain YYYY-MM-DD date.
	asset="buck2-x86_64-unknown-linux-gnu.zst"
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/facebook/buck2/releases/tags/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output --arg asset "${asset}" '.assets[] | select(.name==$asset) | .updated_at' | cut -d'T' -f1)
	folder="${HOME}/install/binaries"
	executable="${folder}/buck2"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^buck2 /{print $2; exit}' | grep -oP '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
	fi
	if bashy_install_check "buck2" "${installed_version}" "${latest_version}"
	then
		after_strict
		return
	fi
	download_file=$(echo "${release_json}" | jq --raw-output --arg asset "${asset}" '.assets[] | select(.name==$asset) | .browser_download_url')
	bashy_install_download "${download_file}"
	local zst
	bashy_download "${download_file}" zst || { after_strict; return; }
	rm -f "${executable}"
	zstd --quiet --decompress "${zst}" -o "${executable}"
	chmod +x "${executable}"
	after_strict
}

function _uninstall_buck2() {
	before_strict
	folder="${HOME}/install/binaries"
	executable="${folder}/buck2"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm -f "${executable}"
	else
		echo "no buck2 detected"
	fi
	# left over from the old published_at based version check
	rm -f "${folder}/.buck2_published_at"
	after_strict
}

function _activate_buck2() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "buck2" __var __error; then return; fi
	eval "$(buck2 completion bash)"
	__var=0
}

register_interactive _activate_buck2

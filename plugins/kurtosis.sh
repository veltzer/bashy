# This is integration of akurtosis (kurtosis on the command line)
# https://docs.kurtosis.com/guides/adding-command-line-completion
function _activate_kurtosis() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "kurtosis" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(kurtosis completion bash)
	then
		__var=$?
		__error="could not source kurtosis completion script"
	fi
	__var=0
}

function _install_kurtosis() {
	local e=errexit_save_and_start
	local release_json latest_version url
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/kurtosis-tech/kurtosis-cli-release-artifacts/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name')
	local install_dir="${HOME}/install/binaries"
	local kurtosis_path="${install_dir}/kurtosis"
	local installed_version=""
	if [ -x "${kurtosis_path}" ]
	then
		installed_version=$("${kurtosis_path}" version 2>/dev/null | grep -oP 'CLI Version:\s+\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "kurtosis" "${installed_version}" "${latest_version}"
	then
		errexit_restore "${e}"
		return
	fi
	url=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	echo "url is [${url}]..."
	local local_file
	bashy_download "${url}" local_file || { errexit_restore "${e}"; return 1; }
	local checksums
	checksums=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("checksums.txt"))')
	bashy_verify_sha256 "${local_file}" "${checksums}" || { errexit_restore "${e}"; return 1; }
	bashy_install_extract "${local_file}" "${install_dir}" kurtosis
	chmod +x "${kurtosis_path}"
	errexit_restore "${e}"
}

function _uninstall_kurtosis() {
	bashy_uninstall_binary "kurtosis"
}

register_interactive _activate_kurtosis

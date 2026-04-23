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
	if [ -x "${kurtosis_path}" ]; then
		local installed_version
		installed_version=$("${kurtosis_path}" version 2>/dev/null | grep -oP 'CLI Version:\s+\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "kurtosis ${latest_version} is already installed (latest)"
			errexit_restore "${e}"
			return
		fi
		echo "kurtosis ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing kurtosis ${latest_version}"
	fi
	url=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	echo "url is [${url}]..."
	local local_file="/tmp/kurtosis.tar.gz"
	curl --fail --silent --location "${url}" --output "${local_file}"
	tar zxf "${local_file}" -C "${install_dir}" kurtosis
	rm -f "${local_file}"
	chmod +x "${kurtosis_path}"
	errexit_restore "${e}"
}

register_interactive _activate_kurtosis

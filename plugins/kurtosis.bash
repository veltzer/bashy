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
	# local version="2.1.0"
	# local url="https://github.com/kurtosis-tech/kurtosis-cli-release-artifacts/releases/download/${version}/kurtosis-cli_${version}_linux_amd64.tar.gz"
	local url
	url=$(curl --silent --location https://api.github.com/repos/kurtosis-tech/kurtosis-cli-release-artifacts/releases/latest | jq --raw-output '.assets[].browser_download_url | select(endswith("_linux_amd64.tar.gz"))')
	local local_file="/tmp/kurtosis.tar.gz"
	local install_dir="${HOME}/install/binaries"
	local kurtosis_path="${install_dir}/kurtosis"
	curl --silent -L "${url}" -o "${local_file}"
	tar zxf "${local_file}" -C "${install_dir}" kurtosis
	chmod +x "${kurtosis_path}"
	errexit_restore "${e}"
}

register_interactive _activate_kurtosis

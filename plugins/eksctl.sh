# this is a plugin for the eksctl aws tool
#
# References:
# - https://eksctl.io/introduction/#installation

function _activate_eksctl() {
	local -n __var=$1
	local -n __error=$2
	EKSCTL_BINARY="${HOME}/install/binaries/eksctl"
	if ! checkExecutableFile "${EKSCTL_BINARY}" __var __error; then return; fi
	export EKSCTL_BINARY
	# shellcheck source=/dev/null
	if ! source <(eksctl completion bash)
	then
		__var=$?
		__error="could not source eskctl bash completions"
		return
	fi
	__var=0
}

function _install_eksctl() {
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/eksctl-io/eksctl/releases/latest" | jq --raw-output '.tag_name' | sed 's/^v//')
	executable="${HOME}/install/binaries/eksctl"
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" version 2>/dev/null | head -1)
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "eksctl ${latest_version} is already installed (latest)"
			return
		fi
		echo "eksctl ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing eksctl ${latest_version}"
	fi
	rm -f "${executable}"
	curl --fail --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C "${HOME}/install/binaries" eksctl
}

function eksctl_uninstall() {
	rm -f "${EKSCTL_BINARY}"
}

register_interactive _activate_eksctl

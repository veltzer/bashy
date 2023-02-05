# this is a plugin for the eksctl aws tool
#
# References:
# - https://eksctl.io/introduction/#installation

function _activate_eksctl() {
	local -n __var=$1
	local -n __error=$2
	EKSCTL_BINARY="$HOME/install/binaries/eksctl"
	if ! checkExecutableFile "$EKSCTL_BINARY" __var __error; then return; fi
	export EKSCTL_BINARY
	# shellcheck source=/dev/null
	source <(eksctl completion bash)
	__var=0
}

function eksctl_install() {
	rm -f /tmp/eskctl
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl "${EKSCTL_BINARY}"
	rm -f /tmp/eskctl
}

function eksctl_uninstall() {
	rm -f "${EKSCTL_BINARY}"
}

register_interactive _activate_eksctl

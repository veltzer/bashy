# This plugin checks that you have helm(1) in your path
# and knows now to install it.
#
# References:
# - https://helm.sh/docs/intro/install/

function _activate_helm() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "helm" __var __error; then return; fi
	eval "$(helm completion bash)"
	__var=0
}

function _install_helm() {
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/helm/helm/releases/latest" | jq --raw-output '.tag_name')
	executable="${HOME}/install/binaries/helm"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" version --short 2>/dev/null | grep -oP '^v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
	fi
	if bashy_install_check "helm" "${installed_version}" "${latest_version}"
	then
		return
	fi
	rm -f "${executable}" /tmp/get_helm.sh
	curl --fail --silent --location --show-error --output "/tmp/get_helm.sh" "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
	chmod +x /tmp/get_helm.sh
	HELM_INSTALL_DIR="${HOME}/install/binaries" /tmp/get_helm.sh --no-sudo
	rm -f /tmp/get_helm.sh
}

register _activate_helm

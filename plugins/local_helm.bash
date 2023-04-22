# This plugin checks that you have helm(1) in your path
# and knows now to install it.
#
# References:
# - https://helm.sh/docs/intro/install/

function _activate_helm() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath helm __var __error; then return; fi
	__var=0
}

function _install_helm() {
	rm -f "${HOME}/install/binaries/helm" /tmp/get_helm.sh
	curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod +x /tmp/get_helm.sh
	HELM_INSTALL_DIR="${HOME}/install/binaries" /tmp/get_helm.sh --no-sudo
	rm -f /tmp/get_helm.sh
}

register _activate_helm

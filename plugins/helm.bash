function _activate_helm() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath helm __var __error; then return; fi
	__var=0
}

function _install_helm() {
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

register _activate_helm

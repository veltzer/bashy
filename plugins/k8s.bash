function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
	K8S_HOME="${HOME}/install/k8s"
	if ! checkDirectoryExists "${K8S_HOME}" __var __error; then return; fi
	export K8S_HOME
	pathutils_add_head PATH "${K8S_HOME}"
	if ! checkInPath kubectl __var __error; then return; fi
	# shellcheck disable=1090
	source <(kubectl completion bash)
	__var=0
}

function _install_k8s() {
	# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
	version=$(curl --silent --location https://dl.k8s.io/release/stable.txt)
	echo "installing version ${version}"
	rm -rf "${HOME}/install/k8s" || true
	mkdir -p "${HOME}/install/k8s"
	curl --location --silent --output "${HOME}/install/k8s/kubectl" "https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl"
	chmod +x "${HOME}/install/k8s/kubectl"
}

register _activate_k8s

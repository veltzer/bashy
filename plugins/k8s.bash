function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
	K8S_HOME="${HOME}/install/k8s"
	if ! checkDirectoryExists "${K8S_HOME}" __var __error; then return; fi
	export K8S_HOME
	_bashy_pathutils_add_head PATH "${K8S_HOME}"
	if ! checkInPath "kubectl" __var __error; then return; fi
	# shellcheck disable=1090
	source <(kubectl completion bash)
	__var=0
}

function _install_k8s() {
	set +e
	# instructions for installing k8s are at
	# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
	if true
	then
		version=$(curl --silent --location "https://dl.k8s.io/release/stable.txt")
		echo "installing latest version ${version}"
	else
		version="v1.26.7"
		echo "installing hardcoded version ${version}"
	fi
	folder="${HOME}/install/k8s"
	executable="${folder}/kubectl"
	rm -rf "${folder}" || true
	mkdir -p "${folder}"
	curl --location --silent --output "${executable}" "https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl"
	chmod +x "${executable}"
}

function _uninstall_k8s() {
	folder="${HOME}/install/k8s"
	if [ -d "${folder}" ]
	then
		echo "removing ${folder}"
		rm -rf "${folder}"
	else
		echo "no k8s detected"
	fi
}

register _activate_k8s

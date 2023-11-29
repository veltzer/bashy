# this is a plugin to:
# provide install for latest kubectl
# provide bash completions for kubectl(1)

function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
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
	folder="${HOME}/install/binaries"
	executable="${folder}/kubectl"
	curl --location --silent --output "${executable}" "https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl"
	chmod +x "${executable}"
}

function _uninstall_k8s() {
	folder="${HOME}/install/binaries"
	executable="${folder}/kubectl"
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm "${executable}"
	else
		echo "no kubectl detected"
	fi
}

register _activate_k8s

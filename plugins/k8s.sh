# this is a plugin for kubectl and the like
# provide install for latest kubectl
# provide bash completions for kubectl(1)

function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "kubectl" __var __error; then return; fi
	# shellcheck source=/dev/null
	if ! source <(kubectl completion bash)
	then
		__var=1
		__error="problem in sourcing kubectl completion"
		return
	fi
	__var=0
}

function _install_k8s() {
	before_install
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
	after_install
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

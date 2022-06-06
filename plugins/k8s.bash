function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
	K8S_HOME="${HOME}/install/k8s"
	if ! checkDirectoryExists "$K8S_HOME" __var __error; then return; fi
	export K8S_HOME
	pathutils_add_head PATH "${K8S_HOME}"
	# shellcheck disable=1090
	source <(kubectl completion bash)
	__var=0
}

register _activate_k8s

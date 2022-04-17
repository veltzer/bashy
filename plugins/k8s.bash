function configure_k8s() {
	local -n __var=$1
	local -n __error=$2
	K8S_HOME="${HOME}/install/k8s"
	if [ ! -d "${K8S_HOME}" ]
	then
		__error="[${K8S_HOME}] doesnt exist"
		__var=1
		return
	fi
	export K8S_HOME
	pathutils_add_head PATH "${K8S_HOME}"
	source <(kubectl completion bash)
	__var=0
}

register configure_k8s

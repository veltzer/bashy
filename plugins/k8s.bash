function configure_k8s() {
	local -n __var=$1
	K8S_HOME="${HOME}/install/k8s"
	if [ -d "${K8S_HOME}" ]
	then
		export K8S_HOME
		pathutils_add_head PATH "${K8S_HOME}"
		__var=0
		return
	fi
	__var=1
}

register configure_k8s

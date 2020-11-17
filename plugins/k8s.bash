function configure_k8s() {
	local __user_var=$1
	K8S_HOME="${HOME}/install/k8s"
	if [ -d "${K8S_HOME}" ]
	then
		export K8S_HOME
		pathutils_add_head PATH "${K8S_HOME}"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_k8s

function configure_k8s() {
	local __user_var=$1
	K8S_HOME="${HOME}/install/k8s"
	if [ -d "${K8S_HOME}" ]
	then
		pathutils_add_head PATH "${K8S_HOME}"
		var_set_by_name "$__user_var" 0
	fi
	var_set_by_name "$__user_var" 1
}

register configure_k8s

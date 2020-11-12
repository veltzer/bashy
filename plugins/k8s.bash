function configure_k8s() {
	local __user_var=$1
	if [ -d "${HOME}/install/k8s" ]
	then
		pathutils_add_head PATH "${HOME}/install/k8s"
		var_set_by_name "$__user_var" 0
	fi
	var_set_by_name "$__user_var" 1
}

register configure_go

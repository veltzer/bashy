# This script manages your k8s environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# k8s cluster for you.

k8s_conf_file_name=".k8s.conf"

function k8s_prompt() {
	if ! git_is_inside
	then
		unset KUBECONFIG
		return
	fi

	git_root=""
	git_top_level git_root
	k8s_configuration_name="${git_root}/${k8s_conf_file_name}"
	if [ -r "${k8s_configuration_name}" ]
	then
		export KUBECONFIG="${k8s_configuration_name}"
	else
		unset KUBECONFIG
	fi
}

function _activate_k8s_prompt() {
	local -n __var=$1
	local -n __error=$2
	prompt_register k8s_prompt
	__var=0
}

register_interactive _activate_k8s_prompt

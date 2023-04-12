# This script manages your k8s environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# k8s cluster for you.

k8s_conf_file_name=".k8s.conf"

function k8s_prompt() {
	assoc_new k8s_conf
	export k8s_conf

	if git_is_inside
	then
		unset KUBECONFIG
		return
	fi

	export k8s_home_conf_file="$HOME/$k8s_conf_file_name"
	if [ -r "$k8s_home_conf_file" ]
	then
		assoc_config_read k8s_conf "$k8s_home_conf_file"
	fi

	git_root=""
	git_top_level git_root
	if [ -r "$git_root/$k8s_conf_file_name" ]
	then
		assoc_config_read k8s_conf "$git_root/$k8s_conf_file_name"
	fi

	# get the configuration name
	export k8s_configuration_name
	assoc_get k8s_conf k8s_configuration_name "k8s_configuration_name"

	# set the envrionment variable
	if null_is_null "$k8s_configuration_name"
	then
		unset KUBECONFIG
	else
		export KUBECONFIG="$k8s_configuration_name"
	fi
}

# this is the main function for k8s, it takes care of running
# the 'k8s_prompt' function on every prompt.
# This is done via the 'PROMPT_COMMAND' feature of bash.
# This one cannot fail since it does not depend on anything
function _activate_k8s() {
	local -n __var=$1
	local -n __error=$2
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="k8s_prompt; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="k8s_prompt"
	fi
	__var=0
}

register_interactive _activate_k8s
# This script manages your google clound environment for you.
# Whenever you 'cd' into a git folder that has .gcp.conf in it
# it will activate the right google cloud project for you.

gcp_conf_file_name=".gcp.conf"

function gcp_prompt() {
	assoc_new gcp_conf
	export gcp_conf

	if ! git_is_inside
	then
		unset CLOUDSDK_ACTIVE_CONFIG_NAME
		return
	fi

	git_root=""
	git_top_level git_root

	export gcp_home_conf_file="${HOME}/${gcp_conf_file_name}"
	if [ -r "${gcp_home_conf_file}" ]
	then
		assoc_config_read gcp_conf "${gcp_home_conf_file}"
	fi

	if [ -r "${git_root}/${gcp_conf_file_name}" ]
	then
		assoc_config_read gcp_conf "${git_root}/${gcp_conf_file_name}"
	fi

	# get the configuration name
	export gcp_configuration_name
	assoc_get gcp_conf gcp_configuration_name "gcp_configuration_name"

	# set the envrionment variable
	if _bashy_null_is_null "${gcp_configuration_name}"
	then
		unset CLOUDSDK_ACTIVE_CONFIG_NAME
	else
		export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"
	fi
}

function _activate_gcp_prompt() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register gcp_prompt
	__var=0
}

register_interactive _activate_gcp_prompt

# This script manages your google clound environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# google cloud project for you.
#
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

gcp_conf_file_name=".gcp"

function gcp_prompt() {
	assoc_new gcp_conf
	export gcp_conf

	export gcp_home_conf_file="$HOME/$gcp_conf_file_name"
	if [ -r "$gcp_home_conf_file" ]
	then
		assoc_config_read gcp_conf "$gcp_home_conf_file"
	fi

	if [ -r "$gcp_conf_file_name" ]
	then
		assoc_config_read gcp_conf "$gcp_conf_file_name"
	fi

	# get the configuration name
	export gcp_configuration_name
	assoc_get gcp_conf gcp_configuration_name "gcp_configuration_name"

	# set the envrionment variable
	if null_is_null "$gcp_configuration_name"
	then
		unset CLOUDSDK_ACTIVE_CONFIG_NAME
	else
		export CLOUDSDK_ACTIVE_CONFIG_NAME="$gcp_configuration_name"
	fi
}

# this is the main function for gcp, it takes care of running
# the 'gcp_prompt' function on every prompt.
# This is done via the 'PROMPT_COMMAND' feature of bash.
function _activate_gcp() {
	local -n __var=$1
	local -n __error=$2
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="gcp_prompt; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="gcp_prompt"
	fi
	__var=0
}

register_interactive _activate_gcp

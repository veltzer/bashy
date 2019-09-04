# This script manages your google clound environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# google cloud project for you.
# 
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

gcloud_conf_file_name=".myenv"

function gcloud_prompt() {
	assoc_create gcloud_conf
	export gcloud_conf

	export gcloud_home_conf_file="$HOME/$gcloud_conf_file_name"
	if [ -r "$gcloud_home_conf_file" ]
	then
		assoc_config_read gcloud_conf "$gcloud_home_conf_file"
	fi

	if [ -r "$gcloud_conf_file_name" ]
	then
		assoc_config_read gcloud_conf "$gcloud_conf_file_name"
	fi

	# get the configuration name
	export gcloud_configuration_name
	assoc_get gcloud_conf gcloud_configuration_name "gcloud_configuration_name"

	# set the envrionment variable
	if null_is_null "$gcloud_configuration_name"
	then
		unset CLOUDSDK_ACTIVE_CONFIG_NAME
	else
		export CLOUDSDK_ACTIVE_CONFIG_NAME="$gcloud_configuration_name"
	fi
}

# this is the main function for gcloud, it takes care of running
# the 'gcloud_prompt' function on every prompt.
# This is done via the 'PROMPT_COMMAND' feature of bash.
function configure_gcloud() {
	local __user_var=$1
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		export PROMPT_COMMAND="gcloud_prompt; $PROMPT_COMMAND"
	else
		export PROMPT_COMMAND="gcloud_prompt"
	fi
	var_set_by_name "$__user_var" 0
}

register_interactive configure_gcloud

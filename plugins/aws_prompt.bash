# This script manages your aws environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# aws project for you.
#
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

aws_conf_file_name=".aws.conf"

function aws_prompt() {
	assoc_new aws_conf
	export aws_conf

	export aws_home_conf_file="$HOME/$aws_conf_file_name"
	if [ -r "$aws_home_conf_file" ]
	then
		assoc_config_read aws_conf "$aws_home_conf_file"
	fi

	if [ -r "$aws_conf_file_name" ]
	then
		assoc_config_read aws_conf "$aws_conf_file_name"
	fi

	# get the configuration name
	export aws_configuration_name
	assoc_get aws_conf aws_configuration_name "aws_configuration_name"

	# set the envrionment variable
	if null_is_null "$aws_configuration_name"
	then
		unset AWS_PROFILE
	else
		export AWS_PROFILE="$aws_configuration_name"
	fi
}

# this is the main function for aws, it takes care of running
# the 'aws_prompt' function on every prompt.
# This is done via the 'PROMPT_COMMAND' feature of bash.
# This one cannot fail since it does not depend on anything
function _activate_aws() {
	local -n __var=$1
	local -n __error=$2
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="aws_prompt; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="aws_prompt"
	fi
	export AWS_PROMPT=yes
	__var=0
}

register_interactive _activate_aws

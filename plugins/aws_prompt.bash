# This script manages your aws environment for you
#
# Here is what it does:
# - Whenever you 'cd' into a git directory it will activate the right
# aws project for you.

aws_conf_file_name=".aws.conf"

function aws_prompt() {
	assoc_new aws_conf
	export aws_conf

	if ! git_is_inside
	then
		unset AWS_PROFILE
		return
	fi

	git_root=""
	git_top_level git_root

	export aws_home_conf_file="${HOME}/${aws_conf_file_name}"
	if [ -r "${aws_home_conf_file}" ]
	then
		assoc_config_read aws_conf "${aws_home_conf_file}"
	fi

	if [ -r "${git_root}/${aws_conf_file_name}" ]
	then
		assoc_config_read aws_conf "${git_root}/${aws_conf_file_name}"
	fi

	# get the configuration name
	export aws_configuration_name
	assoc_get aws_conf aws_configuration_name "aws_configuration_name"

	# set the envrionment variable
	if _bashy_null_is_null "${aws_configuration_name}"
	then
		unset AWS_PROFILE
	else
		export AWS_PROFILE="${aws_configuration_name}"
	fi
}

function _activate_aws() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register aws_prompt
	__var=0
}

register_interactive _activate_aws

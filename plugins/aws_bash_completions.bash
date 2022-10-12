function _activate_aws_bash_completions() {
	local -n __var=$1
	local -n __error=$2
	# completions for aws (must have 'awscli' package from ubuntu
	# or python module installed)
	if ! checkInPath aws_completer __var __error; then return; fi
	complete -C aws_completer aws
	__var=0
}

function _install_aws_bash_completions() {
	#/usr/bin/pip install --user awscli
	# sudo apt install awscli
	/usr/bin/pip install --user awscliv2
}


register_interactive _activate_aws_bash_completions
register_install _install_bash_completion_aws

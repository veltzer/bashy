# Bash completions for the "aws" command
# The support for this comes from the awscli package and installations
# for that package is under the "awscli" plugin.
# The reason for dividing the "awscli" and "aws_bash_completions" plugins
# is that one is regular and the other interactive plugin.

function _activate_aws_bash_completions() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "aws_completer" __var __error; then return; fi
	complete -C "aws_completer" aws
	__var=0
}


register_interactive _activate_aws_bash_completions
register_install _install_bash_completion_aws

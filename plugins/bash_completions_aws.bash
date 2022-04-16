function configure_bash_completions_aws() {
	local -n __var=$1
	local -n __error=$2
	# completions for aws (must have 'awscli' package from ubuntu
	# or python module installed)
	if ! pathutils_is_in_path aws_completer
	then
		__error "aws_completer not in path"
		__var=1
		return
	fi
	complete -C aws_completer aws
	__var=0
}

register_interactive configure_bash_completions_aws

function install_bash_completions_aws() {
	pip install --user awscli
	sudo apt install awscli
}

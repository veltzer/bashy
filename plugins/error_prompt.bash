# This is an error prompt which prints a message if $? is not 0

function error_prompt() {
	ret=$?
	if [ ${ret} -ne 0 ]
	then
		echo "last command exited with error [${ret}]"
	fi
}

function _activate_error() {
	local -n __var=$1
	local -n __error=$2
	prompt_register "error_prompt"
	__var=0
}

register_interactive _activate_error

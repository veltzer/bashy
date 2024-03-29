# This is an error prompt which prints a message if $? is not 0

function error_prompt() {
	ret=$?
	if [ "${ret}" -ne 0 ]
	then
		if [ "${ret}" -gt 128 ] && [ "${ret}" -lt 193 ]
		then
			sig=$((ret - 128))
			reason=$(kill -l "${sig}")
			echo "last command exited with signal [${reason}]"
		else
			reason="${ret}"
			echo "last command exited with code [${reason}]"
		fi
	fi
}

function _activate_error_prompt() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register error_prompt
	__var=0
}

function _deactivate_error_prompt() {
	_bashy_prompt_deregister error_prompt
}

register_interactive _activate_error_prompt _deactivate_error_prompt

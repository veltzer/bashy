# These are functions to register and unregister prompt functions

function prompt_register() {
	local __function=$1
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="${__function}; ${PROMPT_COMMAND}"
	else
		PROMPT_COMMAND="${__function}"
	fi
}

function prompt_deregister() {
	local -n __function=$1
	PROMPT_COMMAND=${PROMPT_COMMAND//${__function};/}
}

# These are functions to register and unregister prompt functions
# This is an old modules and is not used anymore.
# look at plugins/prompt.bash for a new implementation.

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
	local __function=$1
	# echo "PROMPT_COMMAND is ${PROMPT_COMMAND}"
	PROMPT_COMMAND=${PROMPT_COMMAND//${__function}; /}
	# echo "PROMPT_COMMAND is ${PROMPT_COMMAND}"
}

# These are functions to register and unregister prompt functions
#
# TOOD: have prompt just register a single function and that function
# would hold a list of functions to call during every prompt instead of
# just manipulating the PROMPT_COMMAND variable.

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

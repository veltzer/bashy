# This plugin makes it easier to deal with the bash prompt
# It holds a list of functions to be called on each prompt

function bashy_prompt() {
	for function in "${_BASHY_PROMPT_FUNCTIONS[@]}"
	do
		"${function}"
	done
}

function bashy_prompt_print() {
	array_print _BASHY_PROMPT_FUNCTIONS
}

function _activate_inf_prompt() {
	local -n __var=$1
	local -n __error=$1
	array_new _BASHY_PROMPT_FUNCTIONS
	PROMPT_COMMAND="bashy_prompt"
	__var=0
}

function _bashy_prompt_register() {
	local __function=$1
	array_push _BASHY_PROMPT_FUNCTIONS "${__function}"
}

function _bashy_prompt_deregister() {
	local __function=$1
	array_remove _BASHY_PROMPT_FUNCTIONS "${__function}"
}

register_interactive _activate_inf_prompt

# This is the old prompt implementation

function old_prompt_register() {
	local __function=$1
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="${__function}; ${PROMPT_COMMAND}"
	else
		PROMPT_COMMAND="${__function}"
	fi
}

function old_prompt_deregister() {
	local __function=$1
	# echo "PROMPT_COMMAND is ${PROMPT_COMMAND}"
	PROMPT_COMMAND=${PROMPT_COMMAND//${__function}; /}
	# echo "PROMPT_COMMAND is ${PROMPT_COMMAND}"
}

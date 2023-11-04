# This plugin will register a function to be activated on each prompt
# to check whether a "node_modules/.bin" folder exists and add it to the path.

function node_prompt() {
	if [ -d "node_modules/.bin" ]
	then
		_bashy_pathutils_add_head PATH "node_modules/.bin"
	else
		_bashy_pathutils_remove PATH "node_modules/.bin"
	fi
}

function _activate_node_prompt() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register node_prompt
	__var=0
}

register_interactive _activate_node_prompt

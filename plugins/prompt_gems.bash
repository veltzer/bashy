# This plugin will register a function to be activated on each prompt
# to check whether a "gems/bin" folder exists and add it to the path.

GEMS_PATH="gems/bin"

function gems_prompt() {
	if [ -d "${GEMS_PATH}" ]
	then
		_bashy_pathutils_add_head PATH "${GEMS_PATH}"
	else
		_bashy_pathutils_remove PATH "${GEMS_PATH}"
	fi
}

function _activate_gems_prompt() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register gems_prompt
	__var=0
}

register_interactive _activate_gems_prompt

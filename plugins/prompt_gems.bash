# This plugin will register a function to be activated on each prompt
# to check whether a "gems/bin" folder exists and add it to the path.

function gems_prompt() {
	if [ -d "gems/bin" ]
	then
		_bashy_pathutils_add_head PATH "gems/bin"
	else
		_bashy_pathutils_remove PATH "gems/bin"
	fi
}

function _activate_gems_prompt() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register gems_prompt
	__var=0
}

register_interactive _activate_gems_prompt

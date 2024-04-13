# This plugin will register a function to be activated on each prompt
# to check whether a "gems/bin" folder exists and add it to the path.

gems_path="gems/bin"

function prompt_gems() {
	if [ -d "${gems_path}" ]
	then
		_bashy_pathutils_add_head PATH "${gems_path}"
	else
		_bashy_pathutils_remove PATH "${gems_path}"
	fi
}

function _activate_prompt_gems() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register prompt_gems
	__var=0
}

register_interactive _activate_prompt_gems

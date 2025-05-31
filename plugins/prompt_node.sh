# This plugin will register a function to be activated on each prompt
# to check whether a "node_modules/.bin" folder exists and add it to the path.

node_path="node_modules/.bin"

function prompt_node() {
	if ! git_is_inside
	then
		if var_is_defined PROMPT_NODE_ADDED 
		then
			bashy_log "prompt_node" "${BASHY_LOG_INFO}" "down"
			_bashy_pathutils_remove PATH "${PROMPT_NODE_ADDED}"
			unset PROMPT_NODE_ADDED
		fi
		return
	fi

	git_root=""
	git_top_level git_root
	prompt_node_added="${git_root}/${node_path}"
	if [ -d "${prompt_node_added}" ]
	then
		if var_is_defined PROMPT_NODE_ADDED 
		then
			if [ "${PROMPT_NODE_ADDED}" == "${prompt_node_added}" ]
			then
				return
			else
				bashy_log "prompt_node" "${BASHY_LOG_INFO}" "down"
				_bashy_pathutils_remove PATH "${PROMPT_NODE_ADDED}"
				unset PROMPT_NODE_ADDED
			fi
		fi
		# if ! _bashy_pathutils_is_in_path "${prompt_node_added}"
		bashy_log "prompt_node" "${BASHY_LOG_INFO}" "up"
		export PROMPT_NODE_ADDED="${prompt_node_added}"
		_bashy_pathutils_add_head PATH "${PROMPT_NODE_ADDED}"
	else
		if var_is_defined PROMPT_NODE_ADDED 
		then
			bashy_log "prompt_node" "${BASHY_LOG_INFO}" "down"
			_bashy_pathutils_remove PATH "${PROMPT_NODE_ADDED}"
			unset PROMPT_NODE_ADDED
		fi
	fi
}

function _activate_prompt_node() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register prompt_node
	__var=0
}

register_interactive _activate_prompt_node

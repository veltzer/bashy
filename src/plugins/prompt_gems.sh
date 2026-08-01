# This plugin will register a function to be activated on each prompt
# to check whether a "gems/bin" folder exists and add it to the path.

gems_path="gems/bin"

function prompt_gems() {
	if ! git_is_inside
	then
		if var_is_defined PROMPT_GEMS_ADDED
		then
			bashy_log "prompt_gems" "${BASHY_LOG_INFO}" "down"
			_bashy_pathutils_remove PATH "${PROMPT_GEMS_ADDED}"
			unset PROMPT_GEMS_ADDED
		fi
		return
	fi

	git_root=""
	git_top_level git_root
	prompt_gems_added="${git_root}/${gems_path}"
	if [ -d "${prompt_gems_added}" ]
	then
		if var_is_defined PROMPT_GEMS_ADDED 
		then
			if [ "${PROMPT_GEMS_ADDED}" == "${prompt_gems_added}" ]
			then
				return
			else
				bashy_log "prompt_gems" "${BASHY_LOG_INFO}" "down"
				_bashy_pathutils_remove PATH "${PROMPT_GEMS_ADDED}"
				unset PROMPT_GEMS_ADDED
			fi
		fi
		# if ! _bashy_pathutils_is_in_path "${prompt_gems_added}"
		bashy_log "prompt_gems" "${BASHY_LOG_INFO}" "up"
		export PROMPT_GEMS_ADDED="${prompt_gems_added}"
		_bashy_pathutils_add_head PATH "${PROMPT_GEMS_ADDED}"
	else
		if var_is_defined PROMPT_GEMS_ADDED 
		then
			bashy_log "prompt_gems" "${BASHY_LOG_INFO}" "down"
			_bashy_pathutils_remove PATH "${PROMPT_GEMS_ADDED}"
			unset PROMPT_GEMS_ADDED
		fi
	fi
}

function _activate_prompt_gems() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register prompt_gems
	__var=0
}

register_interactive _activate_prompt_gems

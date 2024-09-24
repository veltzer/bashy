# This plugin sources .auto.enter.sh whenever it sees it and
# .auto.exit.sh when it leaves that folder.
#
# TODO
# - this only looks at the current folder and not at the git root

auto_file_enter=".auto.enter.sh"
auto_file_exit=".auto.exit.sh"

function prompt_auto() {
	if ! git_is_inside
	then
		if var_is_defined AUTO_ACTIVE
		then
			bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "down"
			auto_file_exit_full="${AUTO_ACTIVE}/${auto_file_exit}"
			if [ -f "${auto_file_exit_full}" ]
			then
				bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "sourcing [${auto_file_exit_full}]"
				# shellcheck source=/dev/null
				source "${auto_file_exit_full}"
			fi
			unset AUTO_ACTIVE
		fi
		return
	fi

	git_root=""
	git_top_level git_root
	auto_file_enter_full="${git_root}/${auto_file_enter}"
	if [ -r "${auto_file_enter_full}" ]
	then
		if var_is_defined AUTO_ACTIVE
		then
			if [ "${git_root}" != "${AUTO_ACTIVE}" ]
			then
				# we need to get out of a previous auto
				auto_file_exit_full="${AUTO_ACTIVE}/${auto_file_exit}"
				if [ -f "${auto_file_exit_full}" ]
				then
					bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "sourcing [${auto_file_exit_full}]"
					# shellcheck source=/dev/null
					source "${auto_file_exit_full}"
				fi
				unset AUTO_ACTIVE
			else
				return
			fi
		fi
		# we need to enter the new environment
		bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "sourcing [${auto_file_enter_full}]"
		# shellcheck source=/dev/null
		source "${auto_file_enter_full}"
		export AUTO_ACTIVE="${git_root}"
	else
		if var_is_defined AUTO_ACTIVE
		then
			# we need to get out of a previous auto
			auto_file_exit_full="${AUTO_ACTIVE}/${auto_file_exit}"
			if [ -f "${auto_file_exit_full}" ]
			then
				bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "sourcing [${auto_file_exit_full}]"
				# shellcheck source=/dev/null
				source "${auto_file_exit_full}"
			fi
			unset AUTO_ACTIVE
		fi
	fi
}

function _activate_prompt_auto() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register prompt_auto
	__var=0
}

register_interactive _activate_prompt_auto

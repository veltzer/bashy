# This plugin sources .auto.enter.sh whenever it sees it and
# .auto.exit.sh when it leaves that folder.

auto_file_enter=".auto.enter.sh"
auto_file_exit=".auto.exit.sh"

function prompt_auto() {
	if [ -f "${auto_file_enter}" ]
	then
		if var_is_defined AUTO_ACTIVE
		then
			if [ "${PWD}" != "${AUTO_ACTIVE}" ]
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
		auto_file_enter_full="${PWD}/${auto_file_enter}"
		bashy_log "prompt_auto" "${BASHY_LOG_INFO}" "sourcing [${auto_file_enter_full}]"
		# shellcheck source=/dev/null
		source "${auto_file_enter_full}"
		export AUTO_ACTIVE="${PWD}"
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

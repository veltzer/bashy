# This plugin manages environment specific scripts for you.
#
# Here is what it does:
# - Whenever you 'cd' into a git repo for which there is a .env.enter.sh
# at the root it will source it for you.
# - Whenever you 'cd' out of a git repo for which there is a .env.exit.sh
# at the root it will source it for you.
# .env.exit.sh script (if exists)
#
# Technical notes:
# - the sourcing is always done relative to the root of the git tree. This works this way now.
# - this should work if you only have .env.enter.sh or .env.exit.sh
# but I have not checked it to work this way (TODO).

export _BASHY_ENV_DEBUG=1
export ENV_ACTIVE=""
env_file_enter=".env.enter.sh"
env_file_exit=".env.exit.sh"

# function to issue a message if we are in debug mode
function env_debug() {
	local msg=$1
	if [ "${_BASHY_ENV_DEBUG}" = 0 ]
	then
		echo "env: debug: ${msg}"
	fi
}

function env_debug_on() {
	_BASHY_ENV_DEBUG=0
}

function env_debug_off() {
	_BASHY_ENV_DEBUG=1
}

function prompt_env() {
	if ! git_is_inside
	then
		if var_is_defined ENV_ACTIVE
		then
			# we are in an environment
			# need to run .env.exit.sh if it exists and then turn off ENV_ACTIVE
			git_file_full="${ENV_ACTIVE}/${env_file_exit}"
			if [ -r "${git_file_full}" ]
			then
				cd "${ENV_ACTIVE}" || true
				env_debug "sourcing [${env_file_exit}]"
				# shellcheck source=/dev/null
				source "${env_file_exit}"
				unset ENV_ACTIVE
				cd - > /dev/null || true
			fi
		fi
		return
	fi
	git_root=""
	git_top_level git_root
	if ! var_is_defined ENV_ACTIVE
	then
		# in git but no env active, this means
		# - there is no need to turn run .env.exit.sh from previous env
		# - can now digest .env.enter.sh and define ENV_ACTIVE
		git_file_full="${git_root}/${env_file_enter}"
		if [ -r "${git_file_full}" ]
		then
			export ENV_ACTIVE="${git_root}"
			cd "${ENV_ACTIVE}" || true
			env_debug "sourcing [${env_file_enter}]"
			# shellcheck source=/dev/null
			source "${env_file_enter}"
			cd - > /dev/null || true
		fi
		return
	fi
	if [ "${ENV_ACTIVE}" != "${git_root}" ]
	then
		# switched repo, exit and then enter
		git_file_full="${ENV_ACTIVE}/${env_file_exit}"
		if [ -r "${git_file_full}" ]
		then
			cd "${ENV_ACTIVE}" || true
			env_debug "sourcing [${env_file_exit}]"
			# shellcheck source=/dev/null
			source "${env_file_exit}"
			unset ENV_ACTIVE
			cd - > /dev/null || true
		fi
		git_file_full="${git_root}/${env_file_enter}"
		if [ -r "${git_file_full}" ]
		then
			export ENV_ACTIVE="${git_root}"
			cd "${ENV_ACTIVE}" || true
			env_debug "sourcing [${env_file_enter}]"
			# shellcheck source=/dev/null
			source "${env_file_enter}"
			cd - > /dev/null || true
		fi
	fi
}

function _activate_prompt_env() {
	local -n __var=$1
	local -n __error=$2
	_bashy_prompt_register prompt_env
	__var=0
}

register_interactive _activate_prompt_env

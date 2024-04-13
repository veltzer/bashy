# This plugin manages environment specific scripts for you.
#
# Here is what it does:
# - Whenever you 'cd' into a directory git for which there is a .env.enter.sh
# at the root it will activate it for you.
# - Whenyou move out of this directory it will activate the
# .env.exit.sh script (if exists)

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
			git_file="${ENV_ACTIVE}/${env_file_exit}"
			if [ -r "${git_file}" ]
			then
				env_debug "sourcing [${git_file}]"
				# shellcheck source=/dev/null
				source "${git_file}"
				unset ENV_ACTIVE
			fi
		fi
		return
	fi
	if ! var_is_defined ENV_ACTIVE
	then
		# in git but no env active, this means
		# - there is no need to turn run .env.exit.sh
		# - can now digest .env.enter.sh and define ENV_ACTIVE
		git_root=""
		git_top_level git_root
		git_file="${git_root}/${env_file_enter}"
		if [ -r "${git_file}" ]
		then
			env_debug "sourcing [${git_file}]"
			# shellcheck source=/dev/null
			source "${git_file}"
			export ENV_ACTIVE="${git_root}"
		fi
		return
	fi
	git_root=""
	git_top_level git_root
	if [ "${ENV_ACTIVE}" != "${git_root}" ]
	then
		# switched repo, exit and then enter
		git_file="${ENV_ACTIVE}/${env_file_exit}"
		if [ -r "${git_file}" ]
		then
			env_debug "sourcing [${git_file}]"
			# shellcheck source=/dev/null
			source "${git_file}"
			unset ENV_ACTIVE
		fi
		git_file="${git_root}/${env_file_enter}"
		if [ -r "${git_file}" ]
		then
			env_debug "sourcing [${git_file}]"
			# shellcheck source=/dev/null
			source "${git_file}"
			export ENV_ACTIVE="${git_root}"
			env_debug "ENV_ACTIVE=${ENV_ACTIVE}"
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

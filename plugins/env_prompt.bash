# This plugin manages envrionment specific scripts for you.
#
# Here is what it does:
# - Whenever you 'cd' into a directory for which there is a .env.enter.sh
# file in the directory or in any of it's ancestors it will activate
# it for you.
# - Whenyou move out of this directory it will activate the
# .env.exit.sh script (if exists)

export _BASHY_ENV_DEBUG=1
export _BASHY_ENV_ACTIVE=0
export ENV_ACTIVE=""

# function to issue a message if we are in debug mode
function env_debug() {
	local msg=$1
	if [ "${_BASHY_ENV_DEBUG}" = 0 ]
	then
		echo "env: debug: $msg"
	fi
}

function env_debug_on() {
	_BASHY_ENV_DEBUG=0
}

function env_debug_off() {
	_BASHY_ENV_DEBUG=1
}

function env_active_on() {
	_BASHY_ENV_ACTIVE=0
}

function env_active_off() {
	_BASHY_ENV_ACTIVE=1
}

function env_prompt() {
	if [ "${_BASHY_ENV_ACTIVE}" = 1 ]
	then
		env_debug "plugin is deactivated"
		return
	fi
	if git_is_inside
	then
		if [ -z "$ENV_ACTIVE" ]
		then
			# in git but no env active, this means
			# - there is no need to turn run .env.exit.sh
			# - can now source .env.enter.sh and define ENV_ACTIVE
			git_top_level GIT_REPO
			GIT_FILE="$GIT_REPO/.env.enter.sh"
			if [ -r "$GIT_FILE" ]
			then
				env_debug "sourcing [${GIT_FILE}]"
				# shellcheck source=/dev/null
				source "$GIT_FILE"
			fi
			ENV_ACTIVE="$GIT_REPO"
			env_debug "ENV_ACTIVE=${ENV_ACTIVE}"
		else
			git_top_level GIT_REPO
			if [ "$ENV_ACTIVE" != "$GIT_REPO" ]
			then
				# switched repo, exit and then enter
				GIT_FILE="$ENV_ACTIVE/.env.exit.sh"
				if [ -r "$GIT_FILE" ]
				then
					env_debug "sourcing [${GIT_FILE}]"
					# shellcheck source=/dev/null
					source "$GIT_FILE"
				fi
				ENV_ACTIVE=""
				env_debug "ENV_ACTIVE=${ENV_ACTIVE}"
				git_top_level GIT_REPO
				GIT_FILE="$GIT_REPO/.env.enter.sh"
				if [ -r "$GIT_FILE" ]
				then
					env_debug "sourcing [${GIT_FILE}]"
					# shellcheck source=/dev/null
					source "$GIT_FILE"
				fi
				ENV_ACTIVE="$GIT_REPO"
				env_debug "ENV_ACTIVE=${ENV_ACTIVE}"
			fi
		fi
	else
		if [ -n "$ENV_ACTIVE" ]
		then
			# env active is not empty
			# need to run .env.exit.sh and then turn ENV_ACTIVE to empty
			GIT_FILE="$ENV_ACTIVE/.env.exit.sh"
			if [ -r "$GIT_FILE" ]
			then
				env_debug "sourcing [${GIT_FILE}]"
				# shellcheck source=/dev/null
				source "$GIT_FILE"
			fi
			ENV_ACTIVE=""
			env_debug "ENV_ACTIVE=${ENV_ACTIVE}"
		fi
	fi
}

function _activate_env() {
	local -n __var=$1
	local -n __error=$2
	prompt_register env_prompt
	__var=0
}

register_interactive _activate_env

# This plugin manages envrionment specific scripts for you.
#
# Here is what it does:
# - Whenever you 'cd' into a directory for which there is a .env.enter
# file in the directory or in any of it's ancestors it will activate
# it for you.
# - Whenyou move out of this directory it will activate the
# .env.exit script (if exists)
#
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

function env_in_git() {
	git rev-parse > /dev/null 2> /dev/null
}

function env_git_repo() {
	git rev-parse --show-toplevel
}

function env_prompt() {
	if env_in_git
	then
		if [ -z "$ENV_ACTIVE" ]
		then
			# in git but no env active, this means
			# - there is not need to turn run .env.exit
			# - can now source .env.enter and define ENV_ACTIVE 
			GIT_REPO=$(env_git_repo)
			GIT_FILE="$GIT_REPO/.env.enter"
			if [ -r "$GIT_FILE" ]
			then
				# shellcheck source=/dev/null
				source "$GIT_FILE"
			fi
			ENV_ACTIVE="$GIT_REPO"
		else
			if [ "$ENV_ACTIVE" != "$GIT_REPO" ]
			then
				# switched repo, exit and then enter
				GIT_FILE="$ENV_ACTIVE/.env.exit"
				if [ -r "$GIT_FILE" ]
				then
					# shellcheck source=/dev/null
					source "$GIT_FILE"
				fi
				GIT_REPO=$(env_git_repo)
				GIT_FILE="$GIT_REPO/.env.enter"
				if [ -r "$GIT_FILE" ]
				then
					# shellcheck source=/dev/null
					source "$GIT_FILE"
				fi
				ENV_ACTIVE="$GIT_REPO"
			fi
		fi
	else
		if [ -n "$ENV_ACTIVE" ]
		then
			# env active is not empty
			# need to run .env.exit and then turn ENV_ACTIVE to empty
			GIT_FILE="$ENV_ACTIVE/.env.exit"
			if [ -r "$GIT_FILE" ]
			then
				# shellcheck source=/dev/null
				source "$GIT_FILE"
			fi
			ENV_ACTIVE=""
		fi
	fi
}

# stop the plugin from working
function env_unconfigure() {
	PROMPT_COMMAND=${PROMPT_COMMAND//env_prompt;/}
}

# this is the main function for env, it takes care of running them env
# code on every prompt. This is done via the 'PROMPT_COMMAND' feature
# of bash.
function _activate_env() {
	local -n __var=$1
	local -n __error=$2
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="env_prompt; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="env_prompt"
	fi
	ENV_ACTIVE=""
	__var=0
}

register_interactive _activate_env

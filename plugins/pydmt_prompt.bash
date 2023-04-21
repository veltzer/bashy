# This init script manages your python virtual envrionment for you.
#
# Here is what it does:
# - Whenever you 'cd' into a directory it will activate the right
# virtual env for you.
# - If a virtual env was not created, it will automatically create
# one for you.
# - If a virtual env falls out of sync with the 'requirements.txt'
# file which was used to create it then it will be re-created.
# This is done by comparing the md5 checksum of the 'requirements.txt'
# file and a checksum which is stored inside each created virtual
# environment.
# - to recreate the venvs for a bunch for folders activate:
#	$ pydmt build_venv
# in each the folders.
# - It *is not* enough to just cd into these folders as part of a
# for loop or script since then pydmt_prompt will not be activated.
#
# TODO:
# - make a config which controls how pydmt decides whether to keep the
# venv or not. This way we can enable to keep the venv active when we
# are within the .pydmt directory to any depth.

export _BASHY_PYDMT_DEBUG=1
export _BASHY_PYDMT_ACTIVE=0

function pydmt_debug() {
	local msg=$1
	if [ "${_BASHY_PYDMT_DEBUG}" = 0 ]
	then
		echo "pydmt: debug: $msg"
	fi
}

function pydmt_debug_on() {
	_BASHY_PYDMT_DEBUG=0
}

function pydmt_debug_off() {
	_BASHY_PYDMT_DEBUG=1
}

function pydmt_info() {
	local msg=$1
	# echo "pydmt: info: $msg"
	cecho g "pydmt: info: $msg" 0
}

function pydmt_error() {
	cecho r "pydmt: error: $1" 0
}

function pydmt_prompt() {
	if [ "$_BASHY_PYDMT_ACTIVE" = 1 ]
	then
		pydmt_debug "plugin is deactivated"
	fi
	if [ -n "${VIRTUAL_ENV}" ] && [ -z "${PYDMT_ACTIVE}" ]
	then
		pydmt_debug "in virtual env which is not pydmt related. not doing anything."
		return
	fi
	# if we are in the wrong virtual env, deactivate
	if [ -n "${VIRTUAL_ENV}" ]
	then
		if [ "$(readlink -f ".venv/default")" != "${VIRTUAL_ENV}" ]
		then
			pydmt_debug "deactivating virtual env at [${VIRTUAL_ENV}]"
			deactivate
			PYDMT_ACTIVE=""
		fi
	fi
	if git_is_inside
	then
		pydmt_debug "in git env"
		git_top_level GIT_REPO
		pydmt_debug "GIT_REPO is ${GIT_REPO}"
		if [ -z "$PYDMT_ACTIVE" ]
		then
			pydmt_debug "no active pydmt environment"
			GIT_FILE="$GIT_REPO/.pydmt.config"
			if [ -r "$GIT_FILE" ]
			then
				pydmt_debug "have .pydmt.config file"
				if [ -f .pydmt.build.errors ]
				then
					pydmt_debug "found error file not building"
					return
				fi
				pydmt_debug "running pydmt build_venv in [${GIT_REPO}]"
				if (cd "${GIT_REPO}" || exit 1; pydmt build_venv)
				then
					pydmt_activate="${GIT_REPO}/.venv/default/bin/activate"
					pydmt_debug "activating virtual env [${pydmt_activate}]"
					if [ -r "${pydmt_activate}" ]
					then
						# shellcheck source=/dev/null
						source "${pydmt_activate}"
						PYDMT_ACTIVE="yes"
					else
						pydmt_error "cannot activate virtual env at [${pydmt_activate}]"
					fi
				else
					pydmt_debug "creating error file"
					touch .pydmt.build.errors
				fi
			fi
		fi
	else
		pydmt_debug "not in git environment"
	fi
	# if [ ! "$VIRTUAL_ENV" ]
	# then
	# 	unset pydmt_powerline_virtual_env_python_version
	# fi
}

function _activate_pydmt() {
	local -n __var=$1
	local -n __error=$2
	prompt_register "pydmt_prompt"
	__var=0
}

register_interactive _activate_pydmt

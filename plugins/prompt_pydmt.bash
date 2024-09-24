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
#	pydmt build_venv
# in each the folders.
# - It *is not* enough to just cd into these folders as part of a
# for loop or script since then prompt_pydmt will not be activated.
#
# TODO:
# - make a config which controls how pydmt decides whether to keep the
# venv or not. This way we can enable to keep the venv active when we
# are within the .pydmt directory to any depth.
# - make this plugin be more close to the other prompt_* plugins in structure.
# for instance, it should start with "if ! git_is_inside"...

export _BASHY_PYDMT_ACTIVE=""
export _BASHY_PYDMT_EVENV="${HOME}/.venv"
export _BASHY_PYDMT_TOOL="${HOME}/.venv/bin/pydmt"


function prompt_pydmt() {
	if git_is_inside
	then
		bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "in git env"
		git_root=""
		git_top_level git_root
		bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "git_root is [${git_root}]"
		deactivated_env=""
		if [ -n "${_BASHY_PYDMT_ACTIVE}" ]
		then
			bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "have active pydmt environment"
			new_virtual_env="${git_root}/.venv/default"
			if [ "${new_virtual_env}" != "${VIRTUAL_ENV}" ]
			then
				bashy_log "prompt_pydmt" "${BASHY_LOG_INFO}" "wrong pydmt env, deactivating (${new_virtual_env}, ${VIRTUAL_ENV})"
				python_deactivate
				deactivated_env="${VIRTUAL_ENV}"
				_BASHY_PYDMT_ACTIVE=""
			else
				bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "have the right pydmt env (${new_virtual_env})"
			fi
		fi
		if [ -z "${_BASHY_PYDMT_ACTIVE}" ]
		then
			bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "no active pydmt environment"
			GIT_FILE="${git_root}/.pydmt.config"
			if [ -r "${GIT_FILE}" ]
			then
				bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "have .pydmt.config file"
				if [ -f "${git_root}/.pydmt.build.errors" ]
				then
					bashy_log "prompt_pydmt" "${BASHY_LOG_ERROR}" "found error file not building"
					return
				fi
				bashy_log "prompt_pydmt" "${BASHY_LOG_INFO}" "running pydmt build_venv in [${git_root}]"
				if (cd "${git_root}" || exit 1; ${_BASHY_PYDMT_TOOL} build_venv --add_dev True 2> /tmp/errors)
				then
					bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "created virtualenv using pydmt build_venv"
					if [ -n "${VIRTUAL_ENV}" ]
					then
						bashy_log "prompt_pydmt" "${BASHY_LOG_INFO}" "have external virtual env [${VIRTUAL_ENV}], deactivating"
						python_deactivate
					fi
					python_activate "${git_root}/.venv/default"
					_BASHY_PYDMT_ACTIVE="yes"
				else
					bashy_log "prompt_pydmt" "${BASHY_LOG_ERROR}" "could not create virtual env, creating errors file"
					mv "/tmp/errors" "${git_root}/.pydmt.build.errors"
					# now we need to activate back a previous venv if we had one
					if [ -n "${deactivated_env}" ]
					then
						python_activate "${deactivated_env}/.venv/default"
					fi
				fi
			fi
		fi
	else
		bashy_log "prompt_pydmt" "${BASHY_LOG_DEBUG}" "not in git environment"
		if [ -n "${_BASHY_PYDMT_ACTIVE}" ]
		then
			bashy_log "prompt_pydmt" "${BASHY_LOG_INFO}" "PYDMT is active, deactivating"
			python_deactivate
			_BASHY_PYDMT_ACTIVE=""
			if [ -n "${_BASHY_PYDMT_EVENV}" ]
			then
				python_activate "${_BASHY_PYDMT_EVENV}"
			fi
		fi
	fi
}

function _activate_prompt_pydmt() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "pydmt" __var __error; then return; fi
	_bashy_prompt_register prompt_pydmt
	__var=0
}

register_interactive _activate_prompt_pydmt

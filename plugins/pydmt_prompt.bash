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
# for loop or script since then pydmt_prompt will not be activated.
#
# TODO:
# - make a config which controls how pydmt decides whether to keep the
# venv or not. This way we can enable to keep the venv active when we
# are within the .pydmt directory to any depth.

export _BASHY_PYDMT_DEBUG=1
export _BASHY_PYDMT_ON=0
export _BASHY_PYDMT_ACTIVE=""
export _BASHY_PYDMT_EVENV=""

function pydmt_debug() {
	local msg=$1
	if [ "${_BASHY_PYDMT_DEBUG}" = 0 ]
	then
		echo "pydmt: debug: ${msg}"
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
	# echo "pydmt: info: ${msg}"
	cecho g "pydmt: info: ${msg}" 0
}

function pydmt_error() {
	cecho r "pydmt: error: ${1}" 0
}

function pydmt_prompt() {
	if [ "${_BASHY_PYDMT_ON}" = 1 ]
	then
		pydmt_debug "plugin is deactivated"
	fi
	if git_is_inside
	then
		pydmt_debug "in git env"
		git_top_level GIT_REPO
		pydmt_debug "GIT_REPO is [${GIT_REPO}]"
		deactivated_env=""
		deactivated_pydmt_active=""
		if [ -n "${_BASHY_PYDMT_ACTIVE}" ]
		then
			pydmt_debug "have active pydmt environment"
			new_virtual_env="${GIT_REPO}/.venv/default"
			if [ "${new_virtual_env}" != "${VIRTUAL_ENV}" ]
			then
				pydmt_debug "wrong pydmt env, deactivating (${new_virtual_env}, ${VIRTUAL_ENV})"
				deactivate
				deactivated_env="${VIRTUAL_ENV}"
				deactivated_pydmt_active="${_BASHY_PYDMT_ACTIVE}"
				_BASHY_PYDMT_ACTIVE=""
			else
				pydmt_debug "have the right pydmt env (${new_virtual_env})"
			fi
		fi
		if [ -z "${_BASHY_PYDMT_ACTIVE}" ]
		then
			pydmt_debug "no active pydmt environment"
			GIT_FILE="${GIT_REPO}/.pydmt.config"
			if [ -r "${GIT_FILE}" ]
			then
				pydmt_debug "have .pydmt.config file"
				if [ -f .pydmt.build.errors ]
				then
					pydmt_error "found error file not building"
					return
				fi
				pydmt_debug "running pydmt build_venv in [${GIT_REPO}]"
				if (cd "${GIT_REPO}" || exit 1; pydmt build_venv 2> /tmp/errors)
				then
					pydmt_debug "created virtualenv using pydmt build_venv"
					if [ -n "${VIRTUAL_ENV}" ]
					then
						pydmt_debug "have external virtual env [${VIRTUAL_ENV}, deactivating]"
						_BASHY_PYDMT_EVENV="${VIRTUAL_ENV}"
						deactivate
					else
						pydmt_debug "registering no external venv"
						_BASHY_PYDMT_EVENV=""
					fi
					pydmt_activate="${GIT_REPO}/.venv/default/bin/activate"
					pydmt_debug "activating virtual env [${pydmt_activate}]"
					if [ -r "${pydmt_activate}" ]
					then
						# shellcheck source=/dev/null
						source "${pydmt_activate}"
						_BASHY_PYDMT_ACTIVE="yes"
					else
						pydmt_error "cannot activate virtual env at [${pydmt_activate}]"
					fi
				else
					pydmt_error "could not create virtual env, creating errors file"
					mv /tmp/errors .pydmt.build.errors
					# TODO: if I deactivate a virtual env before trying to create one here.
					# now we need to activate it back.
					if [ -n "${deactivated_env}" ]
					then
						pydmt_activate="${deactivated_env}/.venv/default/bin/activate"
						pydmt_debug "activating virtual env [${pydmt_activate}]"
						if [ -r "${pydmt_activate}" ]
						then
							# shellcheck source=/dev/null
							source "${pydmt_activate}"
							_BASHY_PYDMT_ACTIVE="${deactivated_pydmt_active}"
						else
							pydmt_error "cannot activate virtual env at [${pydmt_activate}]"
						fi
					fi
				fi
			fi
		fi
	else
		pydmt_debug "not in git environment"
		if [ -n "${_BASHY_PYDMT_ACTIVE}" ]
		then
			pydmt_debug "PYDMT is active, deactivating"
			deactivate
			_BASHY_PYDMT_ACTIVE=""
			if [ -n "${_BASHY_PYDMT_EVENV}" ]
			then
				pydmt_debug "activating external venv at [${_BASHY_PYDMT_EVENV}]"
				activate="${_BASHY_PYDMT_EVENV}/bin/activate"
				# shellcheck source=/dev/null
				source "${activate}"
			fi
		fi
	fi
}

function _activate_pydmt() {
	local -n __var=$1
	local -n __error=$2
	prompt_register "pydmt_prompt"
	__var=0
}

register_interactive _activate_pydmt

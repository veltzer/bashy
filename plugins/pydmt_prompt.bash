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
# - to recreate the venvs for a bunch for folders activate
# pydmt_recreate in each the folders. It *is not* enough to just
# cd into these folders as part of a command line since then
# PROMPT_COMMAND will not be activated.
#
# Below are APIs to the general public - do not break them.
#
# How to force creation of a virual env:
# $ pydmt_create
# How to recreate a environment if need be:
# $ pydmt_recreate
#
# TODO: (this is a the TODO list for pydmt until it becomes
# a project on it's own)
# - when i'm inside a git repos ".git" folder pydmt still does git
# commands and I get an error since you are not supposed to use these
# git commands when you're in the ".git" folder.
# - the md5 must be made out of the requirements and the python version.
# we once had the pydmt configuration file added to requirements
# but this is wrong since there could be many pydmt configuration files.
# we just want the python version and the requirements.txt file.
# - do not read the config again if the data of the pydmt config files
# did not change (performance enhancement).
# - make a config which controls how pydmt decides whether to keep the
# venv or not. This way we can enable to keep the venv active when we
# are within the .pydmt directory to any depth.

pydmt_errors=".pydmt.venv.errors"
pydmt_virtual_env_folder=".venv/default"
pydmt_activate="${pydmt_virtual_env_folder}/local/bin/activate"

export _BASHY_PYDMT_DEBUG=1
export _BASHY_PYDMT_ACTIVE=0

function pydmt_in_git() {
	git rev-parse > /dev/null 2> /dev/null
}

function pydmt_git_repo() {
	git rev-parse --show-toplevel
}

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

# function to issue a message even if we are not in debug mode
function pydmt_info() {
	local msg=$1
	# echo "pydmt: info: $msg"
	cecho g "pydmt: info: $msg" 0
}

function pydmt_create_virtualenv() {
	# do not create virtualenv if there are error files
	if [ -f "${pydmt_errors}" ]
	then
		pydmt_error "not creating virtual env because error file [${pydmt_errors}] exits"
		return 1
	fi

	# create a virtual env
	pydmt_info "creating new..."
	pydmt build_venv > "${pydmt_errors}"
	local code=$?
	if [ $code -ne 0 ]
	then
		pydmt_error "could not create virtual env. see errors in [${pydmt_errors}]"
		rm -rf "${pydmt_virtual_env_folder}"
		return $code
	fi
	rm -f "${pydmt_errors}"
	pydmt_info "created virtualenv [${pydmt_virtual_env_folder}]"
	# shellcheck source=/dev/null
	source "${pydmt_activate}"
	PYDMT_ACTIVE="yes"
	pydmt_info "entered virtualenv"
	return 0
}

function pydmt_in_virtual_env() {
	[ -n "${VIRTUAL_ENV}" ]
}

function pydmt_error() {
	cecho r "pydmt: error: $1" 0
}

function pydmt_deactivate() {
	pydmt_debug "deactivating virtual env"
	deactivate
	PYDMT_ACTIVE=""
}

function pydmt_deactivate_soft() {
	if pydmt_in_virtual_env
	then
		pydmt_deactivate
	fi
}

function pydmt_activate_soft() {
	if [ -z "${VIRTUAL_ENV}" ]
	then
		pydmt_debug "activating virtual env soft"
		if [ -r "${pydmt_activate}" ]
		then
			# shellcheck source=/dev/null
			source "${pydmt_activate}"
			PYDMT_ACTIVE="yes"
		else
			pydmt_error "cannot activate soft virtual env at [${pydmt_virtual_env_folder}]"
		fi
	fi
}

function pydmt_activate() {
	if [ -n "${VIRTUAL_ENV}" ]
	then
		pydmt_error "in virtual env"
		return
	fi
	if [ -r "${pydmt_activate}" ]
	then
		pydmt_debug "activating virtual env"
		# shellcheck source=/dev/null
		source "${pydmt_activate}"
		PYDMT_ACTIVE="yes"
	else
		pydmt_debug "cannot find activate script"
	fi
}

function pydmt_prompt_inner() {
	if [ -f .pydmt.build.errors ]
	then
		pydmt_debug "found error file not building"
		return
	fi

	pydmt_debug "building env"
	if ! pydmt build_venv
	then
		pydmt_debug "creating error file"
		touch .pydmt.build.errors
	fi
	pydmt_activate_soft
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
	if pydmt_in_virtual_env
	then
		if [ "$(readlink -f "${pydmt_virtual_env_folder}")" != "$VIRTUAL_ENV" ]
		then
			pydmt_deactivate
		fi
	fi
	if pydmt_in_git
	then
		if [ -z "$PYDMT_ACTIVE" ]
		then
			GIT_REPO=$(env_git_repo)
			GIT_FILE="$GIT_REPO/.pydmt.config"
			if [ -r "$GIT_FILE" ]
			then
				pydmt_debug "running pydmt build_venv in [${GIT_REPO}]"
				(cd "${GIT_REPO}" || exit 1; pydmt build_venv)
			fi
		fi
	fi
	if [ ! "$VIRTUAL_ENV" ]
	then
		unset pydmt_powerline_virtual_env_python_version
	fi
}

# stop the plugin from working
function pydmt_unconfigure() {
	PROMPT_COMMAND=${PROMPT_COMMAND//pydmt_prompt;/}
}

# this is the main function for pydmt, it takes care of running them pydmt
# code on every prompt. This is done via the 'PROMPT_COMMAND' feature
# of bash.
function _activate_pydmt() {
	local -n __var=$1
	local -n __error=$2
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="pydmt_prompt; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="pydmt_prompt"
	fi
	__var=0
}

register_interactive _activate_pydmt

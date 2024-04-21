# These are utility functions regarding the python programming
# language

# A function that returns the short version of the python interpreter
function python_version_short() {
	local __user_var=$1
	local python=$2
	local version
	version=$("${python}" --version 2>&1)
	# retain only what is after the last space (Python 3.5.3 -> 3.5.3)
	version="${version##* }"
	# retain only what is before the last dot (3.5.3 -> 3.5)
	version="${version%.*}"
	eval "${__user_var}=\"${version}\""
}

function python_activate() {
	local folder=$1
	local activate="${folder}/bin/activate"
	if [ -r "${activate}" ]
	then
		bashy_log "core/python" "${BASHY_LOG_INFO}" "activating virtual env [${folder}]"
		# shellcheck source=/dev/null
		source "${activate}"
	else
		bashy_log "core/python" "${BASHY_LOG_ERROR}" "cannot activate virtual env at [${folder}]"
	fi
}

function python_deactivate() {
	deactivate
}

# my own version of activation and deactivate of a python virtual env
function new_python_activate() {
	local folder=$1
	# first deactivate an environment
	python_deactivate
	bashy_log "core/python" "${BASHY_LOG_DEBUG}" "activating venv"
	export PYTHON_VENV_ACTIVE="${folder}"
	_bashy_pathutils_add_head PATH "${folder}/bin"
	export PYTHONHOME="${folder}"
	export VIRTUAL_ENV="${folder}"
}

# deactivate a virtual env if we are in one
function new_python_deactivate() {
	if var_is_defined PYTHON_VENV_ACTIVE
	then
		bashy_log "core/python" "${BASHY_LOG_DEBUG}" "deactivating venv"
		_bashy_pathutils_remove PATH "${folder}/bin"
		unset PYTHON_VENV_ACTIVE
	else
		bashy_log "core/python" "${BASHY_LOG_DEBUG}" "no venv active"
	fi
}

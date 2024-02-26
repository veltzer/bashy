# The is the main entry point of bashy
#
# Here is the general flow here:
#
# _bashy_load_core - loads core functions under ~/.bashy/core/*.bash
# _bashy_read_plugins - reads which plugins you want loaded
# 	from either ~/.bashy.list or ~/.bashy/bashy.list
# _bashy_load_plugins - loads the plugins you wanted from
# 	~/.bashy/plugins
# 	and
# 	~/.bashy_extra
# _bashy_run_plugins - runs the plugins
#
# Writing bashy plugin:
# - each plugin should be independent and handle just one issue.
# - plugins should not really do anything when sourced, just register
# functions to be called later.
# - order among plugins will be according to their order in bashy.list.
# - plugins are in charge of their own error handling. The plugins are
# run with 'set +e'. The reason is that forcing 'set -e' on all plugins
# is a really bad design descision.

function _bashy_load_core() {
	# cannot use _bashy_source_absolute function here since it is still not loaded (bootstrap problem)
	# shellcheck source=/dev/null
	source "${BASH_SOURCE%/*}/core/source.bash"
	for f in "${BASH_SOURCE%/*}"/core/*.bash
	do
		local _name="${f##*/}"
		_name="${_name%%.*}"
		bashy_core_names+=("${_name}")
		local _result=0
		_bashy_source_absolute "${f}" || _result=1
		bashy_core_res+=("${_result}")
	done
}

function _bashy_read_plugins_filename() {
	local filename=$1
	while read -r line
	do
		if [[ "${line}" =~ ^#.* ]]
		then
			continue
		fi
		if [[ "${line}" =~ ^[[:space:]]*$ ]]
		then
			continue
		fi
		if [[ "${line}" =~ ^-.* ]]
		then
			plugin="${line:1}"
			enabled=0
		else
			plugin="${line}"
			enabled=1
		fi
		_bashy_array_push bashy_array_plugin "${plugin}"
		assoc_set bashy_assoc_enabled "${plugin}" "${enabled}"
	done < "${filename}"
}

function _bashy_read_plugins() {
	filename="${HOME}/.bashy/bashy.list"
	_bashy_read_plugins_filename "${filename}"
	filename="${HOME}/.bashy.list"
	if [ -f "${filename}" ]
	then
		_bashy_read_plugins_filename "${filename}"
	fi
}

function _bashy_load_plugins() {
	for plugin in "${bashy_array_plugin[@]}"
	do
		current_filename="${HOME}/.bashy/plugins/${plugin}.bash"
		if [[ -r "${current_filename}" ]]
		then
			assoc_set bashy_assoc_found "${plugin}" 1
			assoc_set bashy_assoc_filename "${plugin}" "${current_filename}"
		else
			current_filename="${HOME}/.bashy_extra/${plugin}.bash"
			if [[ -r "${current_filename}" ]]
			then
				assoc_set bashy_assoc_found "${plugin}" 1
				assoc_set bashy_assoc_filename "${plugin}" "${current_filename}"
			else
				assoc_set bashy_assoc_found "${plugin}" 0
				continue
			fi
		fi
		debug "loading [${plugin}]"
		_bashy_source_absolute "${current_filename}"
		assoc_set bashy_assoc_source "${plugin}" "$?"
	done
}

function _bashy_load_config() {
	local bashy_config="${HOME}/.bashy.config"
	if [ -f "${bashy_config}" ]
	then
		# cannot use _bashy_source_absolute function here since it is still not loaded
		# shellcheck source=/dev/null
		source "${bashy_config}"
	fi
}

function _bashy_run_plugins() {
	for function in "${_bashy_array_function[@]}"
	do
		local plugin
		assoc_get _bashy_assoc_function plugin "${function}"
		local enabled
		assoc_get bashy_assoc_enabled enabled "${plugin}"
		if [[ "${enabled}" = 0 ]]
		then
			debug "${plugin} disabled"
			continue
		fi
		if is_debug
		then
			debug "running function [${function}]"
		fi
		if is_step
		then
			read -rn 1
		fi
		if is_profile
		then
			local result=
			local error=""
			local diff=
			measure diff "${function}" result error
			assoc_set bashy_assoc_result "${plugin}" "${result}"
			assoc_set bashy_assoc_error "${plugin}" "${error}"
			assoc_set bashy_assoc_diff "${plugin}" "${diff}"
		else
			local result=
			local error=""
			"${function}" result error
			assoc_set bashy_assoc_result "${plugin}" "${result}"
			assoc_set bashy_assoc_error "${plugin}" "${error}"
			assoc_set bashy_assoc_diff "${plugin}" "NO_PROFILE"
		fi
	done
}

function bashy_status_core() {
	((i=0))
	for name in "${bashy_core_names[@]}"
	do
		_bashy_cecho gr "${name}" 1
		res="${bashy_core_res[${i}]}"
		if [ "${res}" = 0 ]
		then
			_bashy_cecho g "\tOK" 0
		else
			_bashy_cecho r "\tERROR" 0
		fi
		((i++))
	done | column -t
}

# show status of plugins and their init success.
# this is different than file status since if a file
# failed to load it may not have installed any plugin
# handlers which may have succeeded in initializing
# or not
function bashy_status_plugins() {
	for plugin in "${bashy_array_plugin[@]}"
	do
		_bashy_cecho gr "${plugin}" 1
		local enabled
		assoc_get bashy_assoc_enabled enabled "${plugin}"
		if [[ "${enabled}" = 1 ]]
		then
			_bashy_cecho g "\tEN" 1
		else
			_bashy_cecho y "\tDI" 1
		fi
		local found
		assoc_get bashy_assoc_found found "${plugin}"
		if [[ "${found}" = 1 ]]
		then
			_bashy_cecho g "\tFOUND_OK" 1
		else
			_bashy_cecho r "\tFOUND_ERROR" 1
			continue
		fi
		# local filename
		# assoc_get bashy_assoc_filename filename "${plugin}"
		# if [[ $filename = 0 ]]
		# then
		# 	_bashy_cecho r "\tNO_FILENAME" 1
		# else
		# 	_bashy_cecho gr "\t${filename}" 1
		# fi
		if [[ "${enabled}" = 1 ]]
		then
			local source
			assoc_get bashy_assoc_source source "${plugin}"
			if [[ "${source}" = 0 ]]
			then
				_bashy_cecho g "\tLOAD_OK" 1
			else
				_bashy_cecho r "\tLOAD_ERROR" 1
			fi
			local result
			assoc_get bashy_assoc_result result "${plugin}"
			if [[ "${result}" = 0 ]]
			then
				_bashy_cecho g "\tRESULT_OK" 1
			else
				_bashy_cecho r "\tRESULT_ERROR" 1
			fi
			if is_profile
			then
				local diff
				assoc_get bashy_assoc_diff diff "${plugin}"
				printf "\t%.3f\n" "${diff}"
			else
				echo
			fi
		else
			_bashy_cecho y "\tNOT_LOADED" 1
			_bashy_cecho y "\tNO_RESULT" 1
			_bashy_cecho y "\tNO_TIME" 0
		fi
	done | column -t
}

function bashy_errors() {
	local i
	((i=0))
	for plugin in "${bashy_array_plugin[@]}"
	do
		local enabled
		assoc_get bashy_assoc_enabled enabled "${plugin}"
		if [[ "${enabled}" = 0 ]]
		then
			debug "${plugin} disabled"
			continue
		fi
		local result
		assoc_get bashy_assoc_result result "${plugin}"
		if [[ "${result}" = 0 ]]
		then
			debug "${plugin} succeeded"
			continue
		fi
		local error
		assoc_get bashy_assoc_error error "${plugin}"
		_bashy_cecho r "${plugin} - [${error}]\n" 1
		((i++))
	done
}

function bashy_debug() {
	_bashy_array_print bashy_array_plugin
}

function bashy_off() {
	if [ -f "${HOME}/.bashy.disable" ]
	then
		echo "bashy is already off"
	else
		touch "${HOME}/.bashy.disable"
		echo "turned bashy off"
	fi
}

function bashy_on() {
	if [ -f "${HOME}/.bashy.disable" ]
	then
		rm "${HOME}/.bashy.disable"
		echo "turned bashy on"
	else
		echo "bashy is already on"
	fi
}

function bashy_version() {
	echo "${BASHY_VERSION_STR}"
}

function _bashy_init() {
	_bashy_load_config
	if [ -f "${HOME}/.bashy.disable" ]
	then
		return
	fi
	declare -ga bashy_core_names
	declare -ga bashy_core_res
	_bashy_load_core
	declare -ga _bashy_array_function
	assoc_new _bashy_assoc_function
	declare -ga bashy_array_plugin
	assoc_new bashy_assoc_found
	assoc_new bashy_assoc_filename
	assoc_new bashy_assoc_source
	assoc_new bashy_assoc_result
	assoc_new bashy_assoc_error
	assoc_new bashy_assoc_diff
	assoc_new bashy_assoc_enabled
	debug "bashy_starting"
	_bashy_read_plugins
	_bashy_load_plugins
	_bashy_run_plugins
	debug "bashy_ending"
	# bashy_errors
}

# now run _bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.bash
# in his ~/.bashrc, so we do this automatically
_bashy_init

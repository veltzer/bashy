# The is the main entry point of bashy....
#
# Here is the general flow here:
#
# _bashy_load_core - loads core functions under ~/.bashy/core/*.bashinc
# _bashy_read_plugins - reads which plugins you wannt loaded
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
	# shellcheck source=/dev/null
	source "${BASH_SOURCE%/*}/core/source.bashinc"
	for f in "${BASH_SOURCE%/*}"/core/*.bashinc
	do
		local _name="${f##*/}"
		_name="${_name%%.*}"
		bashy_core_names+=("$_name")
		local _result=0
		source_absolute "$f" || _result=1
		bashy_core_res+=("$_result")
	done
}

function _bashy_read_plugins() {
	filename="$HOME/.bashy/bashy.list"
	while read -r line
	do
		if [[ $line =~ ^#.* ]]
		then
			continue
		fi
		if [[ $line =~ ^-.* ]]
		then
			plugin="${line:1}"
			enabled=0
		else
			plugin="${line}"
			enabled=1
		fi
		location=
		array_find bashy_array_plugin "$plugin" location
		if [[ "$location" == -1 ]]
		then
			array_push bashy_array_plugin "${plugin}"
			array_push bashy_array_enabled "${enabled}"
		else
			array_set bashy_array_enabled "${location}" "${enabled}"
		fi
	done < "$filename"
	filename="$HOME/.bashy.list"
	if [[ -r $filename ]]
	then
		while read -r line
		do
			if [[ $line =~ ^#.* ]]
			then
				continue
			fi
			if [[ $line =~ ^-.* ]]
			then
				plugin="${line:1}"
				enabled=0
			else
				plugin="${line}"
				enabled=1
			fi
			array_find bashy_array_plugin "$plugin" location
			if [[ $location == -1 ]]
			then
				array_push bashy_array_plugin "${plugin}"
				array_push bashy_array_enabled "${enabled}"
			else
				array_set bashy_array_enabled "${location}" "${enabled}"
			fi
		done < "$filename"
	fi
}

function _bashy_load_plugins() {
	((i=0))
	for plugin in "${bashy_array_plugin[@]}"
	do
		current_filename="$HOME/.bashy/plugins/$plugin.bash"
		if [[ -r $current_filename ]]
		then
			bashy_array_found+=(1)
			bashy_array_filename+=("$current_filename")
		else
			current_filename="$HOME/.bashy_extra/$plugin.bash"
			if [[ -r $current_filename ]]
			then
				bashy_array_found+=(1)
				bashy_array_filename+=("$current_filename")
			else
				bashy_array_found+=(0)
				bashy_array_filename+=(0)
				bashy_array_function+=(0)
				bashy_array_source+=("---")
				continue
			fi
		fi
		enabled="${bashy_array_enabled[$i]}"
		if [[ $enabled = 1 ]]
		then
			if is_debug
			then
				echo "bashy: loading [$plugin]..."
			fi
			# shellcheck source=/dev/null
			source_absolute "$current_filename" > /dev/null 2> /dev/null
			bashy_array_source+=($?)
		else
			bashy_array_function+=(0)
			bashy_array_source+=("---")
		fi
		((i++))
	done
}

function _bashy_load_config() {
	source "$HOME/.bashy.config"
}

function _bashy_run_plugins() {
	for function in "${bashy_array_function[@]}"
	do
		if [[ $function = 0 ]]
		then
			bashy_array_result+=("NO_RESULT")
			bashy_array_diff+=("NO_TIME")
			continue
		fi
		if is_debug
		then
			echo "$function"
		fi
		if is_step
		then
			read -rn 1
		fi
		if is_profile
		then
			local result
			local diff
			measure diff "$function" result
			bashy_array_result+=("$result")
			bashy_array_diff+=("$diff")
		else
			local result
			"$function" result
			bashy_array_result+=("$result")
			bashy_array_diff+=("NO_PROFILE")
		fi
	done
}

function bashy_status_core() {
	for name in "${bashy_core_names[@]}"
	do
		cecho gr "$name" 1
		res="${bashy_core_res[$i]}"
		if [ "$res" = 0 ]
		then
			cecho g "\tOK" 0
		else
			cecho r "\tERROR" 0
		fi
	done | column -t
}

# show status of plugins and their init success.
# this is different than file status since if a file
# failed to load it may not have installed any plugin
# handlers which may have succeeded in initializing
# or not...
function bashy_status_plugins() {
	((i=0))
	for plugin in "${bashy_array_plugin[@]}"
	do
		cecho gr "${plugin}" 1
		local enabled="${bashy_array_enabled[$i]}"
		if [[ $enabled = 1 ]]
		then
			cecho g "\tEN" 1
		else
			cecho y "\tDI" 1
		fi
		local found="${bashy_array_found[$i]}"
		if [[ $found = 1 ]]
		then
			cecho g "\tFOUND_OK" 1
		else
			cecho r "\tFOUND_ERROR" 1
		fi
		# local filename="${bashy_array_filename[$i]}"
		# if [[ $filename = 0 ]]
		# then
		# 	cecho r "\tNO_FILENAME" 1
		# else
		# 	cecho gr "\t${filename}" 1
		# fi
		if [[ $enabled = 1 ]]
		then
			local source="${bashy_array_source[$i]}"
			if [[ $source = 0 ]]
			then
				cecho g "\tLOAD_OK" 1
			else
				cecho r "\tLOAD_ERROR" 1
			fi
			local result="${bashy_array_result[$i]}"
			if [[ $result = 0 ]]
			then
				cecho g "\tRESULT_OK" 1
			else
				cecho r "\tRESULT_ERROR" 1
			fi
			if is_profile
			then
				local diff="${bashy_array_diff[$i]}"
				printf "\t%.3f\n" "$diff"
			else
				echo
			fi
		else
			cecho y "\tNOT_LOADED" 1
			cecho y "\tNO_RESULT" 1
			cecho y "\tNO_TIME" 0
		fi
		((i++))
	done | column -t
}

declare -a bashy_core_names
declare -a bashy_core_res

declare -a bashy_array_plugin
declare -a bashy_array_enabled
declare -a bashy_array_found
declare -a bashy_array_filename
declare -a bashy_array_source
declare -a bashy_array_result
declare -a bashy_array_diff

function _bashy_init() {
	_bashy_load_core
	_bashy_read_plugins
	_bashy_load_plugins
	_bashy_load_config
	_bashy_run_plugins
}

# now run _bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.bash
# in his ~/.bashrc
_bashy_init

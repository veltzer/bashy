# The is the main entry point of bashy....
#
# Here is the general flow here:
#
# bashy_load_core - loads core functions under ~/.bashy/core/*.bashinc
# bashy_read_plugins - reads which plugins you wannt loaded
# 	from either ~/.bashy.list or ~/.bashy/bashy.list
# bashy_load_plugins - loads the plugins you wanted from
# 	~/.bashy/plugins
# 	and
# 	~/.bashy_extra
# bashy_run_plugins - runs the plugins
# 
# Writing bashy plugin:
# - each plugin should be independent and handle just one issue.
# - plugins should not really do anything when sourced, just register
# functions to be called later.
# - order among plugins will be according to their order in bashy.list.
# - plugins are in charge of their own error handling. The plugins are
# run with 'set +e'. The reason is that forcing 'set -e' on all plugins
# is a really bad design descision.

function bashy_load_core() {
	source ${BASH_SOURCE%/*}/core/source.bashinc
	for f in ${BASH_SOURCE%/*}/core/*.bashinc
	do
		local _name="${f##*/}"
		_name="${_name%%.*}"
		bashy_core_names+=("$_name")
		local _result=0
		source_absolute "$f" || _result=1
		bashy_core_res+=("$_result")
	done
}

function bashy_read_plugins() {
	filename="$HOME/.bashy/bashy.list"
	while read line
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
	filename="$HOME/.bashy.list"
	if [[ -r $filename ]]
	then
		while read line
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
				array_set bashy_array_enabled "$location" "$enabled"
			fi
		done < "$filename"
	fi
}

function bashy_load_plugins() {
	let "i=0"
	for plugin in "${bashy_array_plugin[@]}"
	do
		enabled="${bashy_array_enabled[$i]}"
		if [[ $enabled = 1 ]]
		then
			bashy_array_found+=(0)
			bashy_array_filename+=("---not-found---")
			bashy_array_source+=("-1")
			continue
		fi
		current_filename="$HOME/.bashy/plugins/$plugin.bash"
		if [[ ! -r $current_filename ]]
		then
			current_filename="$HOME/.bashy_extra/$plugin.bash"
			if [[ ! -r $current_filename ]]
			then
				bashy_array_found+=(0)
				bashy_array_filename+=("---not-found---")
				bashy_array_source+=("-1")
				continue
			fi
		fi
		bashy_array_found+=(1)
		bashy_array_filename+=("$current_filename")
		if is_debug
		then
			echo "bashy: loading [$plugin]..."
		fi
		source_absolute $current_filename > /dev/null 2> /dev/null
		bashy_array_source+=($?)
		let "i++"
	done
}

function bashy_run_plugins() {
	for function in "${bashy_array_function[@]}"
	do
		if is_debug
		then
			echo $function
		fi
		if is_step
		then
			read -n 1
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
			bashy_array_diff+=(0)
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
	let "i=0"
	for plugin in "${bashy_array_plugin[@]}"
	do
		cecho gr "${plugin}" 1
		local enabled="${bashy_array_enabled[$i]}"
		if [[ $enabled = 1 ]]
		then
			cecho g "\tEN" 1
		else
			cecho r "\tDI" 1
		fi
		local found="${bashy_array_found[$i]}"
		if [[ $found = 1 ]]
		then
			cecho g "\tFOUND_OK" 1
		else
			cecho r "\tFOUND_ERROR" 1
		fi
		local filename="${bashy_array_filename[$i]}"
		cecho gr "\t${filename}" 1
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
		 	printf "\t%.3f\n" $diff
		else
		 	echo
		fi
		let "i++"
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

function bashy_init() {
	bashy_load_core
	bashy_read_plugins
	bashy_load_plugins
	bashy_run_plugins
}

# now run bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.bash
# in his ~/.bashrc
bashy_init

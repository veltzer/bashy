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
	source core/source.bashinc
	for f in core/*.bashinc
	do
		# echo "bashy: loading [$f]..."
		local _name="${f##*/}"
		_name="${_name%%.*}"
		bashy_core_names+=("$_name")
		local _result=0
		source "$f" || _result=1
		bashy_core_res+=("$_result")
	done
}

function bashy_read_plugins() {
	filename="$HOME/.bashy/bashy.list"
	while read line
	do
		if [[ "$line" =~ ^#.* ]]
		then
			continue
		fi
		enabled=1
		if [[ "$line" =~ ^-.* ]]
		then
			plugin="${line:1}"
			enabled=0
		else
			plugin="${line}"
			enabled=1
		fi
		array_find bashy_plugin_array "$plugin" location
		if [[ $location == -1 ]]
		then
			array_push bashy_plugin_array "${line:1}"
			array_push bashy_enabled_array "${enabled}"
		else
			array_set bashy_enabled_array $location $enabled
		fi
	done < "$filename"
	filename="$HOME/.bashy.list.temp"
	if [ -r "$filename" ]
	then
		while read line
		do
			if [[ "$line" =~ ^#.* ]]
			then
				continue
			fi
			array_find bashy_plugin_array "$line" location
			array_set bashy_enabled_array $location 0
		done < "$filename"
	fi
}

function bashy_load_plugins() {
	for elem in "${bashy_plugin_array[@]}"
	do
		current_filename="$HOME/.bashy/plugins/$elem.bash"
		if [ -r $current_filename ]
		then
			bashy_found_array+=(0)
			if is_debug
			then
				echo "bashy: loading [$elem]..."
			fi
			returncode=0
			source $current_filename > /dev/null 2> /dev/null || returncode=1
			bashy_source_array+=("$returncode")
		else
			current_filename="$HOME/.bashy_extra/$elem.bash"
			if [ -r $current_filename ]
			then
				bashy_found_array+=(0)
				if is_debug
				then
					echo "bashy: loading [$elem]..."
				fi
				returncode=0
				source $current_filename > /dev/null 2> /dev/null || returncode=1
				bashy_source_array+=("$returncode")
			else
				bashy_found_array+=(1)
			fi
		fi
	done
}

function bashy_run_plugins() {
	for func in "${bashy_init_array[@]}"
	do
		if is_debug
		then
			echo $func
		fi
		if is_step
		then
			read -n 1
		fi
		if is_profile
		then
			local result
			local diff
			measure diff "$func" result
			bashy_result_array+=("$result")
			bashy_diff_array+=("$diff")
		else
			local result
			"$func" result
			bashy_result_array+=("$result")
		fi
	done
}

function bashy_status_core() {
	for ((i=0;i<${#bashy_core_names[@]};++i))
	do
		name="${bashy_core_names[$i]}"
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

# show status of files and their load success
# this is differnt than plugin status since one file
# can supply 0 or more plugins
function bashy_status_load() {
	for ((i=0;i<${#bashy_plugin_array[@]};++i))
	do
		cecho gr "${bashy_plugin_array[$i]}" 1
		local found="${bashy_found_array[$i]}"
		if [ "$found" = 0 ]
		then
			cecho g "\tFOUND_OK" 1
		else
			cecho r "\tFOUND_ERROR" 1
		fi
		local source="${bashy_source_array[$i]}"
		if [ "$source" = 0 ]
		then
			cecho g "\tLOAD_OK" 1
		else
			cecho r "\tLOAD_ERROR" 1
		fi
		echo
	done | column -t
}

# show status of plugins and their init success.
# this is different than file status since if a file
# failed to load it may not have installed any plugin
# handlers which may have succeeded in initializing
# or not...
function bashy_status_plugins() {
	for ((i=0;i<${#bashy_init_array[@]};++i))
	do
		cecho gr "${bashy_init_array[$i]}" 1
		local result="${bashy_result_array[$i]}"
		if [ "$result" = 0 ]
		then
			cecho g "\tRESULT_OK" 1
		else
			cecho r "\tRESULT_ERROR" 1
		fi
		if is_profile
		then
			local diff="${bashy_diff_array[$i]}"
			printf "\t%.3f\n" $diff
		else
			echo
		fi
	done | column -t
}

declare -a bashy_core_names
declare -a bashy_core_res
declare -a bashy_plugin_array
declare -a bashy_enabled_array
declare -a bashy_found_array
declare -a bashy_source_array
declare -a bashy_result_array
declare -a bashy_diff_array

function bashy_init() {
	bashy_load_core
	bashy_read_plugins
#	bashy_load_plugins
#	bashy_run_plugins
}

# now run bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.bash
# in his ~/.bashrc
bashy_init

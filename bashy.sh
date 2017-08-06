# The is the main entry point of bashy....
#
# Here is the general flow here:
#
# bashy_load_core - loads core functions under ~/.bashy/core/*.sh
# bashy_read_plugins - reads which plugins you wannt loaded
# 	from either ~/.bashy.list or ~/.bashy/bashy.list
# bashy_load_plugins - loads the plugins you wanted from
# 	~/.bashy/plugins
# 	and
# 	~/.bashy/external
# bashy_run_plugins - runs the plugins
# 
# Writing bashy scripts:
# - each script should be independent and handle just one issue.
# - scripts should not really do anything when sourced, just register
# functions to be called later.
# - order among script will be according to their order in bashy.list.
# - the scripts are run with '-e' which means that if any error is automatically
# critical. If a script does not wish this it can turn the error mode off with
# 'set +e' but currently it is the script responsiblity to turn it back on
# when it is done with 'set -e'.

function bashy_load_core() {
	for f in $(compgen -G "$HOME/.bashy/core/*.sh")
	do
		name="${f##*/}"
		name="${name%%.*}"
		bashy_core_names+=("$name")
		source "$f"
		bashy_core_res+=($?)
	done
}

function bashy_list_file() {
	filename="$HOME/.bashy/external/bashy.list"
	if [ -r $filename ]
	then
		echo $filename
	else
		filename="$HOME/.bashy/bashy.list"
		echo $filename
	fi
}

function bashy_read_plugins() {
	filename=$(bashy_list_file)
	while read F
	do
		bashy_enabled_array+=($F)
	done < $filename
}

function bashy_load_plugins() {
	for elem in "${bashy_enabled_array[@]}"
	do
		current_filename="$HOME/.bashy/plugins/$elem.sh"
		if [ -r $current_filename ]
		then
			# echo -n "bashy: loading [$elem]..."
			source $current_filename
			bashy_source_array+=($?)
		else
			current_filename="$HOME/.bashy/external/$elem.sh"
			if [ -r $current_filename ]
			then
				# echo -n "bashy: loading [$elem]..."
				source $current_filename
				bashy_source_array+=($?)
			else
				echo "bashy: plugin [$elem] not found"
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
			measure "$func"
			bashy_result_array+=("$result")
			bashy_diff_array+=("$diff")
		else
			"$func"
			bashy_result_array+=("$result")
		fi
	done
}

function bashy_core_status() {
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

function bashy_status() {
	for ((i=0;i<${#bashy_init_array[@]};++i))
	do
		cecho gr "${bashy_init_array[$i]}" 1
		local source="${bashy_source_array[$i]}"
		if [ "$source" = 0 ]
		then
			cecho g "\tLOAD_OK" 1
		else
			cecho r "\tLOAD_ERROR" 1
		fi
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
			local t=$(printf "%.3f" $diff)
			echo -e "\t$t"
		fi
	done | column -t
}

declare -a bashy_core_names
declare -a bashy_core_res
declare -a bashy_enabled_array
declare -a bashy_source_array
declare -a bashy_result_array
declare -a bashy_diff_array

function bashy_init() {
	set -e
	bashy_load_core
	bashy_read_plugins
	bashy_load_plugins
	bashy_run_plugins
	set +e
}

# now run bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.sh
# in his ~/.bashrc
bashy_init

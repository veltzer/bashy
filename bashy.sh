<<'COMMENT'

The is the main entry point of bashy....

Here is the general flow here:

bashy_load_core - loads core functions under ~/.bashy/core/*.sh
bashy_read_plugins - reads which plugins you wannt loaded
	from either ~/.bashy.list or ~/.bashy/bashy.list
bashy_load_plugins - loads the plugins you wanted from
	~/.bashy/plugins
	and
	~/.bashy/external
bashy_run_plugins - runs the plugins

Writing bashy scripts:
- each script should be independent and handle just one issue.
- scripts should not really do anything when sourced, just register
functions to be called later.
- order among script will be according to their order in bashy.list.
- the scripts are run with '-e' which means that if any error is automatically
critical. If a script does not wish this it can turn the error mode off with
'set +e' but currently it is the script responsiblity to turn it back on
when it is done with 'set -e'.

COMMENT

function bashy_load_core() {
	for f in $(compgen -G "$HOME/.bashy/core/*.sh")
	do
		source "$f"
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
			# echo "bashy: loading [$elem]..."
			source $current_filename
		else
			current_filename="$HOME/.bashy/external/$elem.sh"
			if [ -r $current_filename ]
			then
				# echo "bashy: loading [$elem]..."
				source $current_filename
			else
				echo "bashy: plugin [$elem] not found"
			fi
		fi
	done
}

function bashy_run_plugins() {
	for i in "${!bashy_init_array[@]}"
	do
		if is_step
		then
			read -n 1
		fi
		if is_profile
		then
			measure ${bashy_init_array[$i]}
			bashy_res_array+=($?)
			bashy_diff_array+=($diff)
		else
			${bashy_init_array[$i]}
			bashy_res_array+=($?)
		fi
	done
}

function bashy_status() {
	for ((i=0;i<${#bashy_init_array[@]};++i))
	do
		cecho gr "${bashy_init_array[$i]}..." 1
		res="${bashy_res_array[i]}"
		diff="${bashy_diff_array[i]}"
		if is_profile
		then
			local t=$(printf "%.3f" $diff)
		fi
		if [ $res = 0 ]
		then
			cecho g "OK ($t)" 0
		else
			cecho r "ERROR ($t)" 0
		fi
	done
}

declare -a bashy_enabled_array
declare -a bashy_res_array
declare -a bashy_diff_array

function bashy_init() {
	bashy_load_core
	bashy_read_plugins
	bashy_load_plugins
	bashy_run_plugins
}

# now run bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.sh
bashy_init

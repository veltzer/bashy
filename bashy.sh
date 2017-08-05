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

# basic functions that are needed for all subsequent scripts.

function bashy_load_core() {
	for f in $(compgen -G "$HOME/.bashy/core/*.sh"); do
		source "$f"
	done
}

function is_debug() {
	return 1
}

function is_debug_interactive() {
	if is_debug; then
		if is_interactive; then
			return 0
		fi
	fi
	return 1
}

function is_profile() {
	# 0 means profile is on
	# 1 means profile is off
	return 0
}

function is_step() {
	# 0 means step is on
	# 1 means step is off
	return 1
}

function do_source() {
	local filename=$1
	if is_debug; then
		echo "sourcing $filename"
	fi
	source "$filename"
}

# bash does not support sourcing many files at once
# and this is why we use a loop for each of the folders.
function do_folder_sources() {
	local folder=$1
	# FIXME - we do not register the state of nullglob
	# to restore it afterwards...
	shopt -s nullglob
	for f in ~/.bashrc.d/$folder/s*.sh; do
		do_source "$f"
	done
	shopt -u nullglob
}

function source_bashrcd() {
	local x=0
	shopt -s nullglob
	for f in ~/.bashrc.d/enabled/*.sh; do
		# do not fail if a file cannot be read
		if [[ -r "$f" ]]; then
			do_source "$f"
			let "x=x+1"
		else
			cecho r "file [$f] is unreadable" 0
		fi
	done
	shopt -u nullglob
	if is_debug_interactive; then
		echo "sourced [$x] scripts"
	fi
}

function register() {
	local function=$1
	bashy_init_array+=($function)
}

function register_interactive() {
	local function=$1
	if is_interactive
	then
		register "$function"
	fi
}

function bashy_print_bashy_init_array() {
	echo "${bashy_init_array[@]}"
}

function bashy_run_plugins() {
	for i in "${!bashy_init_array[@]}"; do
		if is_step; then
			read -n 1
		fi
		if is_profile; then
			measure ${bashy_init_array[$i]}
			return_value_array+=($?)
			time_array+=($diff)
		else
			${bashy_init_array[$i]}
			return_value_array+=($?)
		fi
	done
}

function bashy_status() {
	for i in "${!bashy_init_array[@]}"; do
		cecho gr "${bashy_init_array[$i]}..." 1
		res=???
		diff=???
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
	echo "${bashy_enabled_array[@]}"
}

function before_uncertain() {
	# set +e
	:
}

function after_uncertain() {
	# set -e
	:
}

function at_start() {
	# enable the following line to get a printout of what exactly you are doing
	#set -x
	#set -o verbose # echo on
	#set -e # stop on any error
	:
}

function at_end() {
	#set +o verbose # echo off
	#set +x
	#set +e
	:
}

function bashy_read_plugins() {
	filename="$HOME/.bashy/bashy.list"
	bashy_enabled_array=()
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
			echo "bashy: loading [$elem]..."
			source $current_filename
		else
			current_filename="$HOME/.bashy/external/$elem.sh"
			if [ -r $current_filename ]
			then
				echo "bashy: loading [$elem]..."
				source $current_filename
			else
				echo "bashy: plugin [$elem] not found"
			fi
		fi
	done
}

function bashy_run_plugins() {
	:
}

function bashy_init() {
	declare -a bashy_init_array
	declare -a return_value_array
	declare -a time_array

	bashy_load_core
	bashy_read_plugins
	bashy_load_plugins
	at_start
	source_bashrcd
	at_end
	bashy_run_plugins
}

# now run bashy_init
# we don't want to force the user to do anything more than source ~/.bashy/bashy.sh
bashy_init

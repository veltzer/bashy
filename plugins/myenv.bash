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
# myenv_recreate in each the folders. It *is not* enough to just
# cd into these folders as part of a command line since then
# PROMPT_COMMAND will not be activated.
#
# Below are APIs to the general public - do not break them.
# 
# How to force creation of a virual env:
# $ myenv_create
# How to recreate a environment if need be:
# $ myenv_recreate
#
# TODO: (this is a the TODO list for myenv until it becomes
# a project on it's own)
# - the md5 must be make out of the requirements and the python version.
# we once had the myenv configuration file added to requirements
# but this is wrong since there could be many myenv configuration files.
# we just want the python version and the requirements.txt file.
# - do not read the config again if the data of the myenv config files
# did not change (performance enhancement).
# 
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

myenv_conf_file_name=".myenv"
myenv_md5_file_name="md5sum"

function myenv_getconf() {
	assoc_create myenv_conf
	export myenv_conf

	# first read the configuration from the home folder
	export myenv_home_conf_file="$HOME/$myenv_conf_file_name"
	if [ -r "$myenv_home_conf_file" ]
	then
		assoc_config_read myenv_conf "$myenv_home_conf_file"
	fi

	# next step over it with local configuration
	if [ -r "$myenv_conf_file_name" ]
	then
		assoc_config_read myenv_conf "$myenv_conf_file_name"
	fi

	# get all the other parameters from the config
	export myenv_virtual_env_python
	export myenv_virtual_env_name
	export myenv_virtual_env_requirement_files

	# general myenv parameters
	export myenv_virtual_env_auto_create
	export myenv_virtual_env_auto_activate
	export myenv_virtual_env_auto_deactivate
	export myenv_debug

	assoc_get myenv_conf myenv_virtual_env_python "virtual_env_python"
	assoc_get myenv_conf myenv_virtual_env_name "virtual_env_name"
	assoc_get myenv_conf myenv_virtual_env_requirement_files "virtual_env_requirement_files"

	assoc_get myenv_conf myenv_virtual_env_auto_create "virtual_env_auto_create"
	assoc_get myenv_conf myenv_virtual_env_auto_activate "virtual_env_auto_activate"
	assoc_get myenv_conf myenv_virtual_env_auto_deactivate "virtual_env_auto_deactivate"
	assoc_get myenv_conf myenv_debug "debug"

	# calculate variables from other variables

	# turn to array
	myenv_virtual_env_requirement_files=($myenv_virtual_env_requirement_files)
	# set the folder to the virtual env
	# export myenv_virtual_env_folder="$HOME/.virtualenvs/$myenv_virtual_env_name"
	export myenv_virtual_env_folder=".venv/$myenv_virtual_env_name"
	# the the python version used (could be used for powerline)
	export myenv_virtual_env_python_version
	python_version_short myenv_virtual_env_python_version "$myenv_virtual_env_python"
}

# function to issue a message if we are in debug mode
function myenv_print_debug() {
	local msg=$1
	if [ "$myenv_debug" = 0 ]
	then
		echo "myenv: debug: $msg"
	fi
}

# function to issue a message even if we are not in debug mode
function myenv_info() {
	local msg=$1
	# echo "myenv: info: $msg"
	cecho g "myenv: info: $msg" 0
}

function myenv_create() {
	myenv_info "creating new venv in [$myenv_virtual_env_folder]"
	rm -rf "$myenv_virtual_env_folder"
	mkdir -p "$myenv_virtual_env_folder"
	virtualenv --clear --quiet "--python=$myenv_virtual_env_python" "$myenv_virtual_env_folder" > /dev/null
	source "$myenv_virtual_env_folder/bin/activate"
	local file
	for file in "${myenv_virtual_env_requirement_files[@]}"
	do
		pip install --quiet -r "$file"
	done
	# no quotes in the next command are a must
	cat "${myenv_virtual_env_requirement_files[@]}" | egrep -v "^#" | sort | md5sum > "$myenv_virtual_env_folder/$myenv_md5_file_name"
}

function myenv_recreate() {
	if [ ! -d "$myenv_virtual_env_folder" ]
	then
		myenv_info "no virtual env found, setting up new virtual env"
		myenv_create
		return
	fi
	if [ ! -f "$myenv_virtual_env_folder/$myenv_md5_file_name" ]
	then
		myenv_info "md5 file is missing, recreating environment"
		myenv_create
		return
	fi
	local a=$(cat "${myenv_virtual_env_requirement_files[@]}" | egrep -v "^#" | sort | md5sum)
	local b=$(cat "$myenv_virtual_env_folder/$myenv_md5_file_name")
	if [ "$a" != "$b" ]
	then
		myenv_info "md5 is out of sync, recreating envrionment"
		myenv_create
		return
	fi
}

function myenv_in_virtual_env() {
	[ -n "${VIRTUAL_ENV}" ]
}

function myenv_error() {
	# echo "$1"
	cecho r "myenv: error: $1" 0
}

function myenv_deactivate_real() {
	myenv_print_debug "deactivating virtual env"
	deactivate
}

function myenv_deactivate() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "not in virtual env"
		return
	fi
	myenv_deactivate_real
}

function myenv_deactivate_soft() {
	if [ "$myenv_virtual_env_auto_deactivate" = 0 ]
	then
		if myenv_in_virtual_env
		then
			myenv_deactivate_real
		fi
	fi
}

function myenv_activate_soft() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_print_debug "activating virtual env"
		if [ -r "$myenv_virtual_env_folder/bin/activate" ]
		then
			source "$myenv_virtual_env_folder/bin/activate"
		else
			myenv_error "cannot activate virtual env at [$myenv_virtual_env_folder]"
		fi
	fi
}

function myenv_activate() {
	if [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "in virtual env"
		return
	fi
	myenv_print_debug "activating virtual env"
	if [ -r "$myenv_virtual_env_folder/bin/activate" ]
	then
		source "$myenv_virtual_env_folder/bin/activate"
	else
		myenv_error "cannot activate virtual env at [$myenv_virtual_env_folder]"
	fi
}

function myenv_prompt_inner() {
	myenv_getconf

	if ! [ -r "$myenv_conf_file_name" ]
	then
		myenv_deactivate_soft
		return
	fi

	local file
	for file in "${myenv_virtual_env_requirement_files[@]}"
	do
		if ! [ -r "$file" ]
		then
			myenv_deactivate_soft
			return
		fi
	done

	# if we are in the wrong virtual env, deactivate
	if myenv_in_virtual_env
	then
		if [ "$(readlink -f "$myenv_virtual_env_folder")" != "$VIRTUAL_ENV" ]
		then
			myenv_deactivate
		fi
	fi
	if [ "$myenv_virtual_env_auto_create" = 0 ]
	then
		myenv_recreate
	fi
	if [ "$myenv_virtual_env_auto_activate" = 0 ]
	then
		myenv_activate_soft
	fi
}

function myenv_prompt() {
	myenv_prompt_inner
	if [ "$VIRTUAL_ENV" ]
	then
		export myenv_powerline_virtual_env_python_version="$myenv_virtual_env_python_version"
	else
		export -n myenv_powerline_virtual_env_python_version=""
	fi
}

# this is the main function for myenv, it takes care of running the myenv
# code on every prompt. This is done via the 'PROMPT_COMMAND' feature
# of bash.
function configure_myenv() {
	local __user_var=$1
	if ! pathutils_is_in_path virtualenv md5sum
	then
		var_set_by_name "$__user_var" 1
		return
	fi
	export PROMPT_COMMAND="myenv_prompt; $PROMPT_COMMAND"
	var_set_by_name "$__user_var" 0
}

register_interactive configure_myenv

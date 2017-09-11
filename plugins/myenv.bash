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
# myenv_prompt in each the folders. It *is not* enough to just
# cd into these folders as part of a command line since then
# PROMPT_COMMAND will not be activated.
# 
# 				Mark Veltzer
#				<mark.veltzer@gmail.com>

myenv_conf_file_name=".myenv"
myenv_md5_file_name="md5sum"

function myenv_getconf() {
	assoc_create myenv_conf
	export myenv_conf

	export myenv_home_conf_file="$HOME/$myenv_conf_file_name"
	if [ -r "$myenv_home_conf_file" ]
	then
		assoc_config_read myenv_conf "$myenv_home_conf_file"
	fi
	assoc_get myenv_conf myenv_read_config_from_git_root "read_config_from_git_root"
	assoc_get myenv_conf myenv_read_config_from_cwd "read_config_from_cwd"

	# get git data if we are in git
	if git_is_inside
	then
		export myenv_in_git=0
		export myenv_git_root
		git_top_level myenv_git_root
		export myenv_git_repo_name
		git_repo_name myenv_git_repo_name
	else
		export myenv_in_git=1
	fi

	# read config from git root if we are in git
	if [ "$myenv_read_config_from_git_root" = 0 ]
	then
		if [ "$myenv_in_git" = 0 ]
		then
			local myenv_conf_file="$myenv_git_root/$myenv_conf_file_name"
			if [ -r "$myenv_conf_file" ]
			then
				assoc_config_read myenv_conf "$myenv_conf_file"
			fi
		fi
	fi

	# read config from the current working directory
	if [ "$myenv_read_config_from_cwd" = 0 ]
	then
		if [ -r "$myenv_conf_file_name" ]
		then
			assoc_config_read myenv_conf "$myenv_conf_file_name"
		fi
	fi

	# set the virual env name
	export myenv_virtual_env_name
	assoc_get myenv_conf myenv_virtual_env_name "virtual_env_name"

	if null_is_null "$myenv_virtual_env_name"
	then
		myenv_virtual_env_name="$myenv_git_repo_name"
	fi

	# set the folder to the virtual env
	export myenv_folder="$HOME/.virtualenvs/$myenv_virtual_env_name"

	# set all the other parameters
	export myenv_python_version myenv_error_deactivate myenv_git_activate myenv_git_deactivate
	export myenv_auto_method myenv_auto_create myenv_auto_activate myenv_auto_deactivate
	export myenv_debug
	assoc_get myenv_conf myenv_python_version "python_version"
	assoc_get myenv_conf myenv_error_deactivate "error_deactivate"
	assoc_get myenv_conf myenv_git_activate "git_activate"
	assoc_get myenv_conf myenv_git_deactivate "git_deactivate"
	assoc_get myenv_conf myenv_auto_method "auto_method"
	assoc_get myenv_conf myenv_auto_create "auto_create"
	assoc_get myenv_conf myenv_auto_activate "auto_activate"
	assoc_get myenv_conf myenv_auto_deactivate "auto_deactivate"
	assoc_get myenv_conf myenv_debug "debug"
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
function myenv_msg() {
	local msg=$1
	echo "myenv: $msg"
}

function myenv_create() {
	mkdir -p "$myenv_folder"
	virtualenv --quiet "--python=/usr/bin/python$myenv_python_version" "$myenv_folder"
	source "$myenv_folder/bin/activate"
	pip install --quiet -r "$myenv_git_root/requirements.txt"
	cat "$myenv_git_root/requirements.txt" | md5sum > "$myenv_folder/$myenv_md5_file_name"
}

function myenv_recreate() {
	if [ ! -d "$myenv_folder" ]
	then
		myenv_msg "no virtual env found, setting up virtual env"
		myenv_create
		return
	fi
	if [ ! -f "$myenv_folder/$myenv_md5_file_name" ]
	then
		myenv_msg "md5 file is missing, recreating environment"
		rm -rf "$myenv_folder"
		myenv_create
		return
	fi
	local a=$(cat "$myenv_git_root/requirements.txt" | md5sum)
	local b=$(cat "$myenv_folder/$myenv_md5_file_name")
	if [ "$a" != "$b" ]
	then
		myenv_msg "md5 is out of sync, recreating envrionment"
		rm -rf "$myenv_folder"
		myenv_create
		return
	fi
}

function myenv_in_virtual_env() {
	[ -n "${VIRTUAL_ENV}" ]
}

function myenv_error() {
	echo "$1"
}

function myenv_deactivate() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "not in virtual env"
		return
	fi
	myenv_print_debug "deactivating virtual env"
	deactivate
}

function myenv_deactivate_soft() {
	if myenv_in_virtual_env
	then
		myenv_print_debug "deactivating virtual env"
		deactivate
	fi
}

function myenv_activate_soft() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_print_debug "activating virtual env"
		source "$myenv_folder/bin/activate"
	fi
}

function myenv_activate() {
	if [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "in virtual env"
		return
	fi
	myenv_print_debug "activating virtual env"
	source "$myenv_folder/bin/activate"
}

function myenv_prompt() {
	myenv_getconf

	found_method=1
	if [ "$myenv_auto_method" = "git" ]
	then
		if ! [ "$myenv_in_git" = 0 ] || ! [ -r "$myenv_git_root/requirements.txt" ]
		then
			myenv_print_debug "getconf or requirements.txt error"
			if [ "$myenv_error_deactivate" = 0 ]
			then
				myenv_deactivate_soft
			fi
			return
		fi
		if git_is_inside
		then
			if [ "$myenv_git_activate" != 0 ]
			then
				myenv_deactivate_soft
				return
			fi
		else
			if [ "$myenv_git_deactivate" = 0 ]
			then
				myenv_deactivate_soft
				return
			fi
		fi
		found_method=0
	fi
	if [ "$myenv_auto_method" = "myenv" ]
	then
		if ! [ -r "$myenv_conf_file_name" ] || ! [ -r "requirements.txt" ]
		then
			myenv_deactivate_soft
			return
		fi
		found_method=0
	fi
	if [ "$found_method" = "1" ]
	then
		myenv_deactivate_soft
		return
	fi

	if [ "$myenv_auto_deactivate" = 0 ]
	then
		# if we are in the wrong virtual env, deactivate
		if myenv_in_virtual_env
		then
			if [ $(readlink -f "$myenv_folder") != "$VIRTUAL_ENV" ]
			then
				myenv_deactivate
			fi
		fi
	fi
	if [ "$myenv_auto_create" = 0 ]
	then
		myenv_recreate
	fi
	if [ "$myenv_auto_activate" = 0 ]
	then
		myenv_activate_soft
	fi
}

# this is the main function for myenv, it takes care of running the myenv
# code on every prompt. This is done via the 'PROMPT_COMMAND' feature
# of bash.
function configure_myenv() {
	local __user_var=$1
	if ! pathutils_is_in_path virtualenv
	then
		var_set_by_name "$__user_var" 1
		return
	fi
	if ! pathutils_is_in_path md5sum
	then
		var_set_by_name "$__user_var" 1
		return
	fi
	export PROMPT_COMMAND="myenv_prompt; $PROMPT_COMMAND"
	var_set_by_name "$__user_var" 0
}

register_interactive configure_myenv

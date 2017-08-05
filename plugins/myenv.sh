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

myenv_conf_file_name=".myenv"
myenv_md5_file_name="md5sum"

function myenv_getconf() {
	if ! git_is_inside
	then
		myenv_debug "not inside git tree, exiting"
		return 1
	fi
	export myenv_git_root=$(git_top_level)
	export myenv_conf_file="$myenv_git_root/$myenv_conf_file_name"
	if ! [ -r "$myenv_conf_file" ]
	then
		myenv_debug "cannot find config $myenv_conf_file for myenv, exiting"
		return 1
	fi
	export myenv_python_version=`grep python_version= $myenv_conf_file | cut -d = -f 2`
	if grep auto= $myenv_conf_file > /dev/null
	then
		export myenv_auto=`grep auto= $myenv_conf_file | cut -d = -f 2`
	else
		export myenv_auto=1
	fi
	local myenv_git_repo_name=$(git_repo_name)
	export myenv_folder="$HOME/.virtualenvs/$myenv_git_repo_name"
	return 0
}

# function to issue a message if we are in debug mode
function myenv_debug() {
	# echo "myenv: debug: $1"
	:
}

# function to issue a message even if we are not in debug mode
function myenv_msg() {
	echo "myenv: $1"
}

function myenv_act_msg() {
	# echo "myenv: act/deact: $1"
	return 0
}

function myenv_create() {
	mkdir -p "$myenv_folder"
	virtualenv --quiet "--python=/usr/bin/python$myenv_python_version" "$myenv_folder"
	source "$myenv_folder/bin/activate"
	pip install --quiet -r "$myenv_git_root/requirements.txt"
	cat "$myenv_git_root/requirements.txt" $myenv_conf_file | md5sum > "$myenv_folder/$myenv_md5_file_name"
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
	local a=$(cat "$myenv_git_root/requirements.txt" $myenv_conf_file | md5sum)
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

# should we deactivate a virtual env when we exit the
# folder for which is it defined?
function myenv_deactivate_out_of_context() {
	return 1
}

function myenv_deactivate() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "not in virtual env"
		return
	fi
	myenv_act_msg "deactivating virtual env"
	deactivate
}

function myenv_deactivate_soft() {
	if myenv_in_virtual_env
	then
		myenv_act_msg "deactivating virtual env"
		deactivate
	fi
}

function myenv_activate_soft() {
	if ! [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_act_msg "activating virtual env"
		source "$myenv_folder/bin/activate"
	fi
}

function myenv_activate() {
	if [ -n "${VIRTUAL_ENV}" ]
	then
		myenv_error "in virtual env"
	fi
	myenv_act_msg "activating virtual env"
	source "$myenv_folder/bin/activate"
}

function myenv_current_virtualenv() {
	echo "$VIRTUAL_ENV"
}

function myenv_prompt() {
	if ! myenv_getconf
	then
		myenv_debug "decided we are not in context, not doing anything"
		if myenv_deactivate_out_of_context
		then
			myenv_deactivate_soft
		fi
		return 0
	fi
	if [ $myenv_auto = 0 ]
	then
		return 0
	fi
	if ! [ -r "$myenv_git_root/requirements.txt" ]
	then
		myenv_debug "did not find requirements, not doing anything"
		if myenv_deactivate_out_of_context
		then
			myenv_deactivate_soft
		fi
		return 0
	fi
	# if we are in the wrong virtual env, deactivate
	if myenv_in_virtual_env
	then
		if [ $(readlink -f $myenv_folder) != $(myenv_current_virtualenv) ]
		then
			myenv_deactivate
		fi
	fi
	myenv_recreate
	myenv_activate_soft
}

# this is the main function for myenv, it takes care of running the myenv
# code on every prompt. This is done via the 'PROMPT_COMMAND' feature
# of bash.
function configure_myenv() {
	if ! pathutils_is_in_path virtualenv
	then
		return 1
	fi
	if ! pathutils_is_in_path md5sum
	then
		return 1
	fi
	export PROMPT_COMMAND="myenv_prompt; $PROMPT_COMMAND"
	return 0
}

register_interactive configure_myenv

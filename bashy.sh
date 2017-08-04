<<'COMMENT'

The is the main entry point of bashy....

It reads the support functions under ~/.bashy.sh
Then it reads all the files under ~/.bashrc.d so that we could split our
bash rc into multiple segments independent of one another.

Writing bashy scripts:
- each script should be independent and handle just one issue.
- scripts should not really do anything when sources, just register
functions to be called later.
- If a script wants to be called ahead of other scripts it can register
itself at the top.
- order among script will currently be random. In the future we may support
order between them.
- the scripts are run with '-e' which means that if any error is automatically
critical. If a script does not wish this it can turn the error mode off with
'set +e' but currently it is the script responsiblity to turn it back on
when it is done with 'set -e'.

COMMENT

# handle input parameters

export BASHY_DEBUG=$1


# basic functions that are needed for all subsequent scripts.

FILE_PATHUTILS="$HOME/.bashy/core/pathutils.sh"
if ! [ -f "$FILE_PATHUTILS" ]
then
	echo "$FILE_PATHUTILS" is missing
	return 1
fi
source "$FILE_PATHUTILS"

FILE_GITUTILS="$HOME/.bashy/core/gitutils.sh"
if ! [ -f "$FILE_GITUTILS" ]
then
	echo "$FILE_GITUTILS" is missing
	return 1
fi
source "$FILE_GITUTILS"


# update just a single apt repo view
# References:
# http://askubuntu.com/questions/65245/apt-get-update-only-for-a-specific-repository
function update_repo() {
	for source in "$@"; do
		sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/${source}" \
		-o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"    
	done
}

function is_in_path() {
	local prog=$1
	hash $prog 2> /dev/null
}

function is_debug() {
	return $BASHY_DEBUG
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

# we check for interactivity using "$- == *i*"
function is_interactive() {
	[[ $- == *i* ]]
}

function do_source() {
	local filename=$1
	#if is_debug; then
	#	echo "sourcing $filename"
	#fi
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

# check if I am on a certain host, expects hostname
function is_hostname() {
	local name=$1
	[ "$HOSTNAME" = "$name" ]
	return $?
}

function cecho() {
	local color=$1
	local text=$2
	local newline=$3
	local code="\033["
	case "$1" in
		black  | bk) color="${code}0;30m";;
		red    |  r) color="${code}1;31m";;
		green  |  g) color="${code}1;32m";;
		yellow |  y) color="${code}1;33m";;
		blue   |  b) color="${code}1;34m";;
		purple |  p) color="${code}1;35m";;
		cyan   |  c) color="${code}1;36m";;
		gray   | gr) color="${code}0;37m";;
	esac
	local text="$color${text}${code}0m"
	if [ $newline = 0 ]; then
		echo -e "$text"
	else
		echo -en "$text"
	fi
}

declare -a init_array
function register() {
	local function=$1
	init_array+=($function)
}

function register_interactive() {
	local function=$1
	if is_interactive
	then
		register "$function"
	fi
}

# print all the initialization functions
function print_init_array() {
	echo "${init_array[@]}"
}

function measure() {
	local function_name=$1
	local start=$(date +%s.%N)
	$function_name
	local ret=$?
	local end=$(date +%s.%N)
	diff=$(echo "$end - $start" | bc -l)
	return $ret
}

function run_registered() {
	if is_debug_interactive; then
		echo "running ${#init_array[@]} of them..."
	fi
	for i in "${!init_array[@]}"; do
		if is_debug_interactive; then
			cecho gr "${init_array[$i]}..." 1
		fi
		if is_step; then
			read -n 1
		fi
		if is_profile; then
			measure ${init_array[$i]}
			res=$?
			local t=$(printf "%.3f" $diff)
			if is_debug_interactive; then
				if [ $res = 0 ]; then
					cecho g "OK ($t)" 0
				else
					cecho r "ERROR ($t)" 0
				fi
			fi
		else
			${init_array[$i]}
			res=$?
			if is_debug_interactive; then
				if [ $res = 0 ]; then
					cecho g "OK" 0
				else
					cecho r "ERROR" 0
				fi
			fi
		fi
	done
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

function run_bashy() {
	at_start
	source_bashrcd
	run_registered
	at_end
}

run_bashy

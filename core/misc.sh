# update just a single apt repo view
# References:
# http://askubuntu.com/questions/65245/apt-get-update-only-for-a-specific-repository
function update_repo() {
	for source in "$@"
	do
		sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/${source}" \
		-o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"    
	done
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
	if [ $newline = 0 ]
	then
		echo -e "$text"
	else
		echo -en "$text"
	fi
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

# we check for interactivity using "$- == *i*"
function is_interactive() {
	[[ $- == *i* ]]
}

function bashy_before_uncertain() {
	set +e
}

function bashy_after_uncertain() {
	set -e
}

function is_debug() {
	# 0 means debug is on
	# 1 means debug is off
	return 1
}

function is_debug_interactive() {
	if is_debug
	then
		if is_interactive
		then
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

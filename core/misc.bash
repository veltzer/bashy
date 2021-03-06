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

# we check for interactivity using "$- == *i*"
function is_interactive() {
	[[ $- == *i* ]]
}

function _bashy_before_thirdparty() {
	:
}

function _bashy_after_thirdparty() {
	:
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

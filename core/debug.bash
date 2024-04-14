function is_debug() {
	declare -p "BASHY_DEBUG" > /dev/null 2> /dev/null
}

function is_debug_interactive() {
	if is_debug
	then
		is_interactive
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
	if ! declare -p "BASHY_STEP" > /dev/null 2> /dev/null
	then
		return 1
	else
		return "${BASHY_STEP}"
	fi
}

function debug() {
	local _message=$1
	if is_debug
	then
		echo "bashy: ${_message}"
	fi
}

function bashy_debug_on() {
	export BASHY_DEBUG="true"
}

function bashy_debug_off() {
	unset BASHY_DEBUG
}

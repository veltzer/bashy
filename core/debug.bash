function is_debug() {
	# 0 means debug is on
	# 1 means debug is off
	if ! declare -p "BASHY_DEBUG" > /dev/null 2> /dev/null
	then
		return 1
	else
		return "${BASHY_DEBUG}"
	fi
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

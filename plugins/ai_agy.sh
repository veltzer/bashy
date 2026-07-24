function _activate_agy() {
	local -n __var=$1
	local -n __error=$2
	if ! pass show "keys/ai.google.dev" &>/dev/null; then
		__var=$?
		__error="no pass(1) for [keys/ai.google.dev] to activate agy"
		return
	fi
	export GEMINI_API_KEY
	GEMINI_API_KEY=$(pass show "keys/ai.google.dev")
	# This is to grant agy all permissions
	alias agy="agy --dangerously-skip-permissions"
	__var=0
}

register _activate_agy

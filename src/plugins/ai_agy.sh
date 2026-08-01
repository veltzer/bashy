function _activate_ai_agy() {
	local -n __var=$1
	local -n __error=$2
	# one pass(1) lookup, not two - each one is a gpg decryption costing ~35ms
	local _key
	if ! _key=$(pass show "keys/ai.google.dev" 2>/dev/null); then
		__var=$?
		__error="no pass(1) for [keys/ai.google.dev] to activate agy"
		return
	fi
	export GEMINI_API_KEY
	GEMINI_API_KEY="${_key}"
	# This is to grant agy all permissions
	alias agy="agy --dangerously-skip-permissions"
	__var=0
}

register _activate_ai_agy

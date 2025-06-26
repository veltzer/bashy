function _activate_gemini() {
	local -n __var=$1
	local -n __error=$2
	if ! pass show "keys/ai.google.dev" &>/dev/null
	then
		__var=$?
		__error="no pass(1) for [keys/ai.google.dev] to activate gemini"
		return
	fi
	export GEMINI_API_KEY
	GEMINI_API_KEY=$(pass show "keys/ai.google.dev")
	__var=0
}

function _install_gemini() {
	before_strict
	go install github.com/reugn/gemini-cli/cmd/gemini@latest
	after_strict
}

register _activate_gemini

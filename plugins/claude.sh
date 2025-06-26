function _activate_claude() {
	local -n __var=$1
	local -n __error=$2
	if ! pass show "keys/claude.ai" &>/dev/null
	then
		__var=$?
		__error="could not source bash_it.sh"
		return
	fi
	ANTHROPIC_API_KEY="$(pass show "keys/claude.ai")"
	export ANTHROPIC_API_KEY
	__var=0
}

function _install_claude() {
	before_strict
	# sudo npm install -g "@anthropic-ai/claude-code"
	npm install -g "@anthropic-ai/claude-code"
	after_strict
}

function _uninstall_claude() {
	before_strict
	# sudo npm uninstall -g "@anthropic-ai/claude-code"
	npm uninstall -g "@anthropic-ai/claude-code"
	after_strict
}

register _activate_claude

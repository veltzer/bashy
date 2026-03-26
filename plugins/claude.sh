function _activate_claude() {
	local -n __var=$1
	local -n __error=$2
	if ! pass show "keys/claude.ai" &>/dev/null; then
		__var=$?
		__error="no pass(1) for [keys/claude.ai] to activate claude.ai"
		return
	fi
	ANTHROPIC_API_KEY="$(pass show "keys/claude.ai")"
	export ANTHROPIC_API_KEY
	alias claude="claude --dangerously-skip-permissions"
	__var=0
}

function _install_claude_npm() {
	before_strict
	# sudo npm install -g "@anthropic-ai/claude-code"
	npm install -g "@anthropic-ai/claude-code@latest"
	after_strict
}

function _install_claude_brew() {
	before_strict
	brew upgrade claude-code
	after_strict
}

function _uninstall_claude() {
	before_strict
	# sudo npm uninstall -g "@anthropic-ai/claude-code"
	npm uninstall -g "@anthropic-ai/claude-code"
	after_strict
}

function _uninstall_claude_brew() {
	before_strict
	brew uninstall claude-code
	after_strict
}

register_interactive _activate_claude

function _activate_claude() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function _install_claude() {
	before_strict
	if node -e "process.exit(parseInt(process.version.slice(1)) < 18 ? 0 : 1)" 2>/dev/null
	then
		echo "Node.js 18+ is NOT installed"
		exit 1
	fi
	sudo npm install -g "@anthropic-ai/claude-code"
	after_strict
}

register _activate_claude

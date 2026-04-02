function _activate_copilot() {
	local -n __var=$1
	local -n __error=$2
  # running via gh(1)
	# alias copilot="gh copilot"
  # without permission checking
  alias copilot="gh copilot --allow-all-tools"
	__var=0
}

function _install_copilot_npm() {
	before_strict
  npm install -g "@github/copilot"
	after_strict
}

function _install_copilt_gh() {
	before_strict
  gh extension install github/gh-copilot
	after_strict
}

register _activate_copilot

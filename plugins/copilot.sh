function _activate_copilot() {
	local -n __var=$1
	local -n __error=$2
  # running via gh(1)
	# alias copilot="gh copilot"
  # without permission checking via gh(1)
  #alias copilot="gh copilot --allow-all-tools"
  # without permission checking via npm
  alias copilot="copilot --allow-all-tools"
	__var=0
}

function _install_copilot_script() {
	before_strict
  curl -fsSL https://gh.io/copilot-install | bash
	after_strict
}

function _install_copilot_npm() {
	before_strict
  npm install -g "@github/copilot"
	after_strict
}

function _uninstall_copilot_npm() {
	before_strict
  npm uninstall -g "@github/copilot"
	after_strict
}

function _install_copilot_gh() {
	before_strict
  gh extension install "github/gh-copilot"
	after_strict
}

function _uninstall_copilot_gh() {
	before_strict
  gh extension remove copilot
	after_strict
}

register _activate_copilot

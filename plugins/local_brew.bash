# This will install brew into your home folder

function _activate_brew() {
	local -n __var=$1
	local -n __error=$2
	BREW_HOME="${HOME}/install/homebrew"
	if ! checkDirectoryExists "${BREW_HOME}" __var __error; then return; fi
	pathutils_add_head PATH "${BREW_HOME}/bin"
	if ! checkInPath brew __var __error; then return; fi
	__var=0
}

function _install_brew() {
	rm -rf "${HOME}/install/homebrew"
	git clone https://github.com/Homebrew/brew "${HOME}/install/homebrew"
	"${HOME}/install/homebrew/bin/brew" update --force --quiet
}

function _uninstall_brew() {
	rm -rf "${HOME}/install/homebrew"
}

register _activate_brew

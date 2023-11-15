# This plugin will make sure you have the brew command at your disposal

function _activate_brew() {
	local -n __var=$1
	local -n __error=$2
	BREW_HOME="${HOME}/install/homebrew"
	if ! checkDirectoryExists "${BREW_HOME}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${BREW_HOME}/bin"
	if ! checkInPath "brew" __var __error; then return; fi
	export BREW_HOME
	# these are needed for homebrew
	export HOMEBREW_PREFIX="${HOME}/install/homebrew";
	export HOMEBREW_CELLAR="${HOME}/install/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="${HOME}/install/homebrew";
	__var=0
}

# https://docs.brew.sh/Installation#untar-anywhere-unsupported
# https://superuser.com/questions/619498/can-i-install-homebrew-without-sudo-privileges
function _install_brew() {
	folder="${HOME}/install/homebrew"
	rm -rf "${folder}"
	git clone "https://github.com/Homebrew/brew" "${folder}"
	"${folder}/bin/brew" update --force --quiet
}

function _uninstall_brew() {
	rm -rf "${HOME}/install/homebrew"
}

register _activate_brew

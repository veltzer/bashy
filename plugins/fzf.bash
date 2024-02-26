function _activate_fzf() {
	local -n __var=$1
	local -n __error=$2
	# it seems that this collides with bash completion
	# stuff so this must be after the system_deafult script
	# which does bash completions.
	if ! checkInPath "fzf" __var __error; then return; fi
	FILE="${HOME}/.fzf.bash"
	if ! checkReadableFile "${FILE}" __var __error; then return; fi
	# shellcheck source=/dev/null
	source "${FILE}"
	__var=0
}

function _install_fzf() {
	# this installs fzf for fuzzy matching
	# https://github.com/junegunn/fzf
	rm -rf "${HOME}/install/fzf" > /dev/null 2> /dev/null
	git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/install/fzf" > /dev/null 2> /dev/null
	"${HOME}/install/fzf/install" --no-update-rc --key-bindings --completion > /dev/null 2> /dev/null
	# sudo apt install fzf
}

register_interactive _activate_fzf
register_install _install_fzf

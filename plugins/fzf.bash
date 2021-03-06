function configure_fzf() {
	local -n __var=$1
	# this installs fzf for fuzzy matching
	# https://github.com/junegunn/fzf
	# it seems that this collides with bash completion
	# stuff so this must be after the system_deafult script
	# which does bash completions.
	FILE="$HOME/.fzf.bash"
	if [ -f "$FILE" ]
	then
		# shellcheck source=/dev/null
		source "$FILE"
		__var=0
		return
	fi
	__var=1
}

function install_fzf() {
	rm -rf ~/.bashy_install/fzf > /dev/null 2> /dev/null
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.bashy_install/fzf > /dev/null 2> /dev/null
	~/.bashy_install/fzf/install --no-update-rc --key-bindings --completion > /dev/null 2> /dev/null
}

register_interactive configure_fzf

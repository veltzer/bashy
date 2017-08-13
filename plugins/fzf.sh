function configure_fzf() {
	# this installs fzf for fuzzy matching
	# it seems that this collides with bash completion
	# stuff so this must be after the system_deafult script
	# which does bash completions.
	FILE="$HOME/.fzf.bash"
	if [ -f "$FILE" ]
	then
		source "$FILE"
		result=0
	else
		result=1
	fi
}

function install_fzf() {
	rm -rf ~/.bashy/install/fzf > /dev/null 2> /dev/null
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.bashy/install/fzf > /dev/null 2> /dev/null
	~/.bashy/install/fzf/install --no-update-rc --key-bindings --completion > /dev/null 2> /dev/null
}

register_interactive configure_fzf

function configure_virtualenvwrapper() {
	local __user_var=$1
	# you can install virtualenvwrapper with
	# $ apt install virtualenvwrapper
	export WORKON_HOME="$HOME/.virtualenvs"
	export PROJECT_HOME="$HOME/git"
	found=false
	if [ -f /usr/local/bin/virtualenvwrapper.sh ] && [ $found = false ]
	then
		FOUND_IN=/usr/local/bin/virtualenvwrapper.sh
		found=true
	fi
	if [ -f ~/.local/bin/virtualenvwrapper.sh ] && [ $found = false ]
	then
		FOUND_IN=~/.local/bin/virtualenvwrapper.sh
		found=true
	fi
	if [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ] && [ $found = false ]
	then
		FOUND_IN=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
		found=true
	fi
	if $found
	then
		# shellcheck source=/dev/null
		source "$FOUND_IN"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_virtualenvwrapper

function configure_virtualenvwrapper() {
	local -n __var=$1
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
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_virtualenvwrapper

function configure_virtualenvwrapper() {
	# you can install virtualenvwrapper with
	# $ apt install virtualenvwrapper
	export WORKON_HOME="$HOME/.virtualenvs"
	export PROJECT_HOME="$HOME/git"
	found=false
	if [ -f /usr/local/bin/virtualenvwrapper.sh -a $found = false ]; then
		FOUND_IN=/usr/local/bin/virtualenvwrapper.sh
		found=true
	fi
	if [ -f ~/.local/bin/virtualenvwrapper.sh -a $found = false ]; then
		FOUND_IN=~/.local/bin/virtualenvwrapper.sh
		found=true
	fi
	if [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh -a $found = false ]; then
		FOUND_IN=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
		found=true
	fi
	if $found; then
		source $FOUND_IN
		return 0
	else
		return 1
	fi
}

register_interactive configure_virtualenvwrapper

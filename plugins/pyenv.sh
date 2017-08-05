function configure_pyenv() {
	# this script sets up pyenv
	export PYENV_ROOT="$HOME/.pyenv"
	if [ -d "$PYENV_ROOT" ] && pathutils_is_in_path pyenv
	then
		export PATH=$(pathutils_add_head "$PATH" "$PYENV_ROOT/bin")
		eval "$(pyenv init -)"
		return 0
	else
		return 1
	fi
}

register_interactive configure_pyenv

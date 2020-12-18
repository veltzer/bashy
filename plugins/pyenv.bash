function configure_pyenv() {
	local -n __var=$1
	PYENV_ROOT="$HOME/.pyenv"
	PYENV_BIN="$PYENV_ROOT/bin"
	if pathutils_is_in_path pyenv && [ -d "$PYENV_ROOT" ] && [ -d "$PYENV_BIN" ]
	then
		export PYENV_ROOT
		export PYENV_BIN
		pathutils_add_head PATH "$PYENV_BIN"
		eval "$(pyenv init -)"
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_pyenv

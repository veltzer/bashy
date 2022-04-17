function configure_pyenv() {
	local -n __var=$1
	local -n __error=$2
	PYENV_ROOT="$HOME/.pyenv"
	PYENV_BIN="$PYENV_ROOT/bin"
	if ! pathutils_is_in_path pyenv
	then
		__error="[pyenv] is not in PATH"
		__var=1
		return
	fi
	if [ ! -d "$PYENV_ROOT" ] || [ ! -d "$PYENV_BIN" ]
	then
		__error="[$PYENV_ROOT] or [$PYENV_BIN] dont exist"
		__var=1
		return
	fi
	export PYENV_ROOT
	export PYENV_BIN
	pathutils_add_head PATH "$PYENV_BIN"
	eval "$(pyenv init -)"
	__var=0
}

register_interactive configure_pyenv

function configure_pyenv() {
	local __user_var=$1
	# this script sets up pyenv
	export PYENV_ROOT="$HOME/.pyenv"
	if [ -d "$PYENV_ROOT" ] && pathutils_is_in_path pyenv
	then
		pathutils_add_head PATH "$PYENV_ROOT/bin"
		eval "$(pyenv init -)"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_pyenv

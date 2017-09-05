function configure_vi_default_editor() {
	local __user_var=$1
	# set up vim as the default editor
	if [[ -x /usr/bin/vim ]]
	then
		export EDITOR='vim'
		export VISUAL='vim'
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_vi_default_editor

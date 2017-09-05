function configure_ls_with_colors() {
	local __user_var=$1
	# ls with colors
	eval `dircolors -b`
	alias ls='ls --color=auto'
	var_set_by_name "$__user_var" 0
}

register_interactive configure_ls_with_colors

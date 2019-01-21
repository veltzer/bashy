function configure_ls() {
	local __user_var=$1
	# ls with colors
	eval `dircolors -b`
	alias ls='ls --color=auto --literal'
	var_set_by_name "$__user_var" 0
}

register_interactive configure_ls

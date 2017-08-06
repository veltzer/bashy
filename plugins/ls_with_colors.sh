function configure_ls_with_colors() {
	# ls with colors
	eval `dircolors -b`
	alias ls='ls --color=auto'
	result=0
}

register_interactive configure_ls_with_colors

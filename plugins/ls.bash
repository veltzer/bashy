function configure_ls() {
	local -n __var=$1
	local -n __error=$2
	# ls with colors
	eval "$(dircolors -b)"
	alias ls='ls --color=auto --literal'
	__var=0
}

register_interactive configure_ls

function _activate_ls() {
	local -n __var=$1
	local -n __error=$2
	# ls with colors
	eval "$(dircolors -b)"
	alias ls='ls --color=auto --literal'
	__var=0
}

function _deactivate_ls() {
	export -n LS_COLORS
	unalias ls
}

register_interactive activate_ls

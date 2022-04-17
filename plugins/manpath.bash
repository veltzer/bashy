function configure_manpath() {
	local -n __var=$1
	local -n __error=$2
	# this causes MANPATH to always have a terminating colon which will
	# cause man(1) to always consult standard paths (from manpath(1)).
	export MANPATH=:
	# you don't need to fiddle with MANPATH since man(1) will look for man pages
	# adjacent to entries you have in your PATH variable.
	# if you define it then man(1) will not search the regular path
	# pathutils_add_tail MANPATH "$HOME/install/share/man"
	__var=0
}

register_interactive configure_manpath

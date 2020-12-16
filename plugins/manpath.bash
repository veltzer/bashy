function configure_manpath() {
	local -n __var=$1
	# this causes MANPATH to always have a terminating colon which will
	# cause man(1) to always consult standard paths (from manpath(1)).
	export MANPATH=:
	__var=0
}

register_interactive configure_manpath

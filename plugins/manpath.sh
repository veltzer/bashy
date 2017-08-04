function configure_manpath() {
	# this causes MANPATH to always have a terminating colon which will
	# cause man(1) to always consult standard paths (from manpath(1)).
	export MANPATH=:
	return 0
}

register_interactive configure_manpath

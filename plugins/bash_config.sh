function configure_bash_config() {
	# this script is where I configure bash to myliking
	# this does not mean aliases, just shopts and sets.

	# allow globstar globbing on the command line (**)
	shopt -s globstar
	# do long completions
	set completeopt=menu,longest
	result=0
}

register_interactive configure_bash_config

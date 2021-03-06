function configure_bash_config() {
	local -n __var=$1
	# this script is where I configure bash to myliking
	# this does not mean aliases, just shopts and sets.

	# allow globstar globbing on the command line (**)
	shopt -s globstar
	# do long completions
	# shellcheck disable=SC2034 # this variable is use by the shell
	completeopt=menu,longest
	__var=0
}

register_interactive configure_bash_config

function _activate_bash_config() {
	local -n __var=$1
	local -n __error=$2
	# this script is where I configure bash to myliking
	# this does not mean aliases, just shopts and sets.

	# allow globstar globbing on the command line (**)
	shopt -s globstar
	# do long completions
	# shellcheck disable=SC2034 # this variable is use by the shell
	completeopt=menu,longest
	__var=0
}

register_interactive _activate_bash_config

function configure_git() {
	return 0
}

function git_root() {
	cd_arg="$(git rev-parse --show-cdup)"
	if [ ! -z "$cd_arg" ]
	then
		cd "$cd_arg"
	fi
}

register_interactive configure_git

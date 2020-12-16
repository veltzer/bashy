function configure_git() {
	local -n __var=$1
	__var=0
}

function git_root() {
	cd_arg="$(git rev-parse --show-cdup)"
	if [ -n "$cd_arg" ]
	then
		cd "$cd_arg" || exit
	fi
}

register_interactive configure_git

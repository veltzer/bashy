function configure_git() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function git_root() {
	# go to the root of the current git repo (if indeed inside a git repo)
	cd_arg="$(git rev-parse --show-cdup)"
	if [ -n "$cd_arg" ]
	then
		cd "$cd_arg" || exit
	fi
}

register_interactive configure_git

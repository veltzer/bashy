function configure_git() {
	local __user_var=$1
	var_set_by_name "$__user_var" 0
}

function git_root() {
	cd_arg="$(git rev-parse --show-cdup)"
	if [ ! -z "$cd_arg" ]
	then
		cd "$cd_arg"
	fi
}

register_interactive configure_git
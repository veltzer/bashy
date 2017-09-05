function configure_path_remove_games() {
	local __user_var=$1
	# remove games
	pathutils_remove PATH "/usr/games"
	pathutils_remove PATH "/usr/local/games"
	var_set_by_name "$__user_var" 0
}

register configure_path_remove_games

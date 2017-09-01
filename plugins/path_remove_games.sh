function configure_path_remove_games() {
	# remove games
	pathutils_remove PATH "/usr/games"
	pathutils_remove PATH "/usr/local/games"
	result=0
}

register configure_path_remove_games

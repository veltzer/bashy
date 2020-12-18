function configure_path_remove_games() {
	local -n __var=$1
	pathutils_remove PATH "/usr/games"
	pathutils_remove PATH "/usr/local/games"
	__var=0
}

register configure_path_remove_games

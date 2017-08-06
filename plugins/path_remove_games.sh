function configure_path_remove_games() {
	# remove games
	export PATH=$(pathutils_remove "$PATH" "/usr/games")
	export PATH=$(pathutils_remove "$PATH" "/usr/local/games")
	result=0
}

register configure_path_remove_games

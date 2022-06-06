function _activate_path_remove_games() {
	local -n __var=$1
	local -n __error=$2
	pathutils_remove PATH "/usr/games"
	pathutils_remove PATH "/usr/local/games"
	__var=0
}

register _activate_path_remove_games

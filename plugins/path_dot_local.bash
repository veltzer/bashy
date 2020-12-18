function configure_path_dot_local() {
	local -n __var=$1
	# This file deals with ~/.local/[bin|lib|man]
	# This folder is meant for local installations.
	# https://askubuntu.com/questions/14535/whats-the-local-folder-for-in-my-home-directory
	FOLDER1="$HOME/.local/bin"
	FOLDER2="$HOME/.local/lib"
	if [ -d "$FOLDER1" ] && [ -d "$FOLDER2" ]
	then
		pathutils_add_head PATH "$FOLDER1"
		pathutils_add_head LD_LIBRARY_PATH "$FOLDER2"
		__var=0
		return
	fi
	__var=1
}

register configure_path_dot_local

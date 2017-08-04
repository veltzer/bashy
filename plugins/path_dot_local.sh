function configure_path_dot_local() {
	# This file deals with ~/.local/[bin|lib|man]
	# This folder is meant for local installations.
	# https://askubuntu.com/questions/14535/whats-the-local-folder-for-in-my-home-directory
	FOLDER1="$HOME/.local/bin"
	FOLDER2="$HOME/.local/lib"
	if [ -d "$FOLDER1" ] && [ -d "$FOLDER2" ]; then
		export PATH=$(pathutils_add_head "$PATH" "$HOME/.local/bin")
		export LD_LIBRARY_PATH=$(pathutils_add_head "$LD_LIBRARY_PATH" "$HOME/.local/lib")
		return 0
	else
		return 1
	fi
}

register configure_path_dot_local

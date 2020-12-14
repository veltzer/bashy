function configure_encfs() {
	local __user_var=$1
	if "$ENCFS_ENABLED"
	then
		if [ -d "$ENCFS_FOLDER_CLEAR" ] && [ -d "$ENCFS_FOLDER_ENCRYPTED" ]
		then
			# mount encrypted file systems: if the folder is not a mountpoint then mount it via encfs
			# the -o allow_other is very important as it allows other users (in particular the apache
			# web server which is running under user www-data) to see this folder
			# mountpoint checks if the mount is already there and ensures we only mount once
			if mountpoint -q "$ENCFS_FOLDER_CLEAR"
			then
				echo "$ENCFS_PASSWORD" | encfs --stdinpass "$ENCFS_FOLDER_ENCRYPTED" "$ENCFS_FOLDER_CLEAR"
			fi
			var_set_by_name "$__user_var" 0
			return
		fi
	fi
	var_set_by_name "$__user_var" 1
}

register configure_encfs

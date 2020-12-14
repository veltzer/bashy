function configure_encfs() {
	local __user_var=$1
	if pathutils_is_in_path encfs
	then
		if "$ENCFS_ENABLED"
		then
			if [ -d "$ENCFS_FOLDER_CLEAR" ] && [ -d "$ENCFS_FOLDER_ENCRYPTED" ]
			then
				# mountpoint checks if the mount is already there and ensures we only mount once
				if mountpoint -q "$ENCFS_FOLDER_CLEAR"
				then
					var_set_by_name "$__user_var" 0
					return
				fi
				echo "$ENCFS_PASSWORD" | encfs --stdinpass "$ENCFS_FOLDER_ENCRYPTED" "$ENCFS_FOLDER_CLEAR"
				var_set_by_name "$__user_var" "$?"
				return
			fi
		fi
	fi
	var_set_by_name "$__user_var" 1
}

register configure_encfs

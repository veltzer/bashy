function configure_encfs() {
	local -n __user_var=$1
	if pathutils_is_in_path encfs
	then
		if "$ENCFS_ENABLED"
		then
			if [ -d "$ENCFS_FOLDER_CLEAR" ] && [ -d "$ENCFS_FOLDER_ENCRYPTED" ]
			then
				# mountpoint checks if the mount is already there and ensures we only mount once
				if mountpoint -q "$ENCFS_FOLDER_CLEAR"
				then
					__var=0
					return
				fi
				echo "$ENCFS_PASSWORD" | encfs --stdinpass "$ENCFS_FOLDER_ENCRYPTED" "$ENCFS_FOLDER_CLEAR"
				__var=$?
				return
			fi
		fi
	fi
	__var=1
}

register configure_encfs

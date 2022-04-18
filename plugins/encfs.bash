function configure_encfs() {
	local -n __var=$1
	local -n __error=$2
	if ! pathutils_is_in_path encfs
	then
		__error="encfs not installed or not in path"
		__var=1
		return
	fi
	if ! "$ENCFS_ENABLED"
	then
		__error="encfs not enabled"
		__var=1
		return
	fi
	if ! checkDirectoryExists "$ENCFS_FOLDER_CLEAR" __var __error; then return; fi
	if ! checkDirectoryExists "$ENCFS_FOLDER_ENCRYPTED" __var __error; then return; fi
	# mountpoint checks if the mount is already there and ensures we only mount once
	if mountpoint -q "$ENCFS_FOLDER_CLEAR"
	then
		# __error="folder $ENCFS_FOLDER_CLEAR already mounted"
		__var=0
		return
	fi
	echo "$ENCFS_PASSWORD" | encfs --stdinpass "$ENCFS_FOLDER_ENCRYPTED" "$ENCFS_FOLDER_CLEAR"
	__var=$?
}

function encfs_umount() {
	fusermount -u "$ENCFS_FOLDER_CLEAR"
}

register configure_encfs

function encfs_install() {
	sudo apt install encfs
}

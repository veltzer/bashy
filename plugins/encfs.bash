function _activate_encfs() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "encfs" __var __error; then return; fi
	if ! "${ENCFS_ENABLED}"
	then
		__error="encfs not enabled"
		__var=1
		return
	fi
	if ! checkDirectoryExists "${ENCFS_FOLDER_CLEAR}" __var __error; then return; fi
	if ! checkDirectoryExists "${ENCFS_FOLDER_ENCRYPTED}" __var __error; then return; fi
	# mountpoint checks if the mount is already there and ensures we only mount once
	if mountpoint -q "${ENCFS_FOLDER_CLEAR}"
	then
		# __error="folder $ENCFS_FOLDER_CLEAR already mounted"
		__var=0
		return
	fi
	echo "${ENCFS_PASSWORD}" | encfs --stdinpass "${ENCFS_FOLDER_ENCRYPTED}" "${ENCFS_FOLDER_CLEAR}"
	__var=$?
}

function encfs_umount() {
	fusermount -u "${ENCFS_FOLDER_CLEAR}"
}

function _install_encfs() {
	sudo apt install encfs
}

register _activate_encfs
register_install _install_encfs

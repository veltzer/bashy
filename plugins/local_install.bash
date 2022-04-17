function configure_local_install() {
	local -n __var=$1
	local -n __error=$2
	LOCAL_INSTALL_BIN="$HOME/install/bin"
	LOCAL_INSTALL_LIB="$HOME/install/lib"
	LOCAL_INSTALL_BINARIES="$HOME/install/binaries"
	if [ ! -d "$LOCAL_INSTALL_BIN" ]
	then
		__error="[$LOCAL_INSTALL_BIN] doesnt exist"
		__var=1
		return
	fi
	if [ ! -d "$LOCAL_INSTALL_LIB" ]
	then
		__error="[$LOCAL_INSTALL_LIB] doesnt exist"
		__var=1
		return
	fi
	if [ ! -d "$LOCAL_INSTALL_BINARIES" ]
	then
		__error="[$LOCAL_INSTALL_BINARIES] doesnt exist"
		__var=1
		return
	fi
	pathutils_add_head PATH "$LOCAL_INSTALL_BIN"
	pathutils_add_head LD_LIBRARY_PATH "$LOCAL_INSTALL_LIB"
	pathutils_add_head PATH "$LOCAL_INSTALL_BINARIES"
	__var=0
}

register configure_local_install

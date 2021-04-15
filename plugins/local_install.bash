function configure_local_install() {
	local -n __var=$1
	LOCAL_INSTALL_BIN="$HOME/install/bin"
	LOCAL_INSTALL_LIB="$HOME/install/lib"
	LOCAL_INSTALL_BINARIES="$HOME/install/binaries"
	if [ -d "$LOCAL_INSTALL_BIN" ] && [ -d "$LOCAL_INSTALL_LIB" ]
	then
		pathutils_add_head PATH "$LOCAL_INSTALL_BIN"
		pathutils_add_head LD_LIBRARY_PATH "$LOCAL_INSTALL_LIB"
	else
		__var=1
		return
	fi
	if [ -d "$LOCAL_INSTALL_BINARIES" ]
	then
		pathutils_add_head PATH "$LOCAL_INSTALL_BINARIES"
		__var=0
	else
		__var=1
		return
	fi
	__var=0
}

register configure_local_install

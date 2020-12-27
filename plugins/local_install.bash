function configure_local_install() {
	local -n __var=$1
	LOCAL_INSTALL_BIN="$HOME/install/bin"
	LOCAL_INSTALL_LIB="$HOME/install/lib"
	if [ -d "$LOCAL_INSTALL_BIN" ] && [ -d "$LOCAL_INSTALL_LIB" ]
	then
		pathutils_add_head PATH "$LOCAL_INSTALL_BIN"
		pathutils_add_head LD_LIBRARY_PATH "$LOCAL_INSTALL_LIB"
		__var=0
		return
	fi
	__var=1
}

register configure_local_install

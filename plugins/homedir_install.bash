function _activate_local_install() {
	local -n __var=$1
	local -n __error=$2
	LOCAL_INSTALL_BIN="${HOME}/install/bin"
	LOCAL_INSTALL_LIB="${HOME}/install/lib"
	LOCAL_INSTALL_BINARIES="${HOME}/install/binaries"
	if ! checkDirectoryExists "${LOCAL_INSTALL_BIN}" __var __error; then return; fi
	if ! checkDirectoryExists "${LOCAL_INSTALL_LIB}" __var __error; then return; fi
	if ! checkDirectoryExists "${LOCAL_INSTALL_BINARIES}" __var __error; then return; fi
	pathutils_add_head PATH "${LOCAL_INSTALL_BIN}"
	pathutils_add_head LD_LIBRARY_PATH "${LOCAL_INSTALL_LIB}"
	pathutils_add_head PATH "${LOCAL_INSTALL_BINARIES}"
	__var=0
}

register _activate_local_install

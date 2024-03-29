function _activate_rust() {
	local -n __var=$1
	local -n __error=$2
	CARGO_HOME="${HOME}/.cargo"
	CARGO_HOME_BIN="${CARGO_HOME}/bin"
	if ! checkDirectoryExists "${CARGO_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${CARGO_HOME_BIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${CARGO_HOME_BIN}"
	export CARGO_HOME
	__var=0
}

function _install_rust() {
	sudo apt install cargo
}

register _activate_rust

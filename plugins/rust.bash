function _activate_rust() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "cargo" __var __error; then return; fi
	if ! checkInPath "rustc" __var __error; then return; fi
	# CARGO_HOME="${HOME}/.cargo"
	CARGO_HOME="${HOME}/install/cargo"
	CARGO_HOME_BIN="${CARGO_HOME}/bin"
	CARGO_ENV="${CARGO_HOME}/env"
	if ! checkDirectoryExists "${CARGO_HOME}" __var __error; then return; fi
	if ! checkDirectoryExists "${CARGO_HOME_BIN}" __var __error; then return; fi
	if ! checkReadableFile "${CARGO_ENV}" __var __error; then return; fi
	# sourcing the cargo env file is just adding ~/.cargo/bin to path at the head.
	# I'd rather do it with my functions.
	# shellcheck source=/dev/null
	# source "${CARGO_ENV}"
	_bashy_pathutils_add_head PATH "${CARGO_HOME_BIN}"
	export CARGO_HOME
	__var=0
}

function _remove_rust() {
	export CARGO_HOME="${HOME}/install/cargo"
	rm -rf "${CARGO_HOME}"
	sudo apt remove cargo rustc rust-src
}

function _install_rust_rustup() {
	export CARGO_HOME="${HOME}/install/cargo"
	export RUSTUP_HOME="${HOME}/.rustup"
	rm -rf "${CARGO_HOME}" "${RUSTUP_HOME}"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function _install_rust_ubuntu() {
	# these are the ubuntu package for rust
	sudo apt install cargo rustc rust-src
}

register _activate_rust

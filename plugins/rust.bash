function configure_rust() {
	local -n __var=$1
	CARGO_HOME="$HOME/.cargo"
	CARGO_HOME_BIN="$CARGO_HOME/bin"
	if [ -d "$CARGO_HOME" ] && [ -d "$CARGO_HOME_BIN" ]
	then
		pathutils_add_head PATH "$CARGO_HOME_BIN"
		export CARGO_HOME
		__var=0
		return
	fi
	__var=1
}

register configure_rust

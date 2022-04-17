function configure_rust() {
	local -n __var=$1
	local -n __error=$2
	CARGO_HOME="$HOME/.cargo"
	CARGO_HOME_BIN="$CARGO_HOME/bin"
	if [ ! -d "$CARGO_HOME" ] || [ ! -d "$CARGO_HOME_BIN" ]
	then
		__error="[$CARGO_HOME] or [$CARGO_HOME_BIN] dont exist"
		__var=1
		return
	fi
	pathutils_add_head PATH "$CARGO_HOME_BIN"
	export CARGO_HOME
	__var=0
}

register configure_rust

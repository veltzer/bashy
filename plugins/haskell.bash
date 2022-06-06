function _activate_haskell() {
	local -n __var=$1
	local -n __error=$2
	CABAL_HOME="$HOME/.cabal"
	if ! checkDirectoryExists "$CABAL_HOME" __var __error; then return; fi
	export CABAL_HOME
	pathutils_add_head PATH "$CABAL_HOME/bin"
	__var=0
}

function haskell_cabal_init() {
	cabal init
}

register _activate_haskell

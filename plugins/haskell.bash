function configure_haskell() {
	local -n __var=$1
	CABAL_HOME="$HOME/.cabal"
	if [ -d "$CABAL_HOME" ]
	then
		export CABAL_HOME
		pathutils_add_head PATH "$CABAL_HOME/bin"
		__var=0
		return
	fi
	__var=1
}

register configure_haskell

function configure_haskell() {
	local -n __var=$1
	local -n __error=$2
	CABAL_HOME="$HOME/.cabal"
	if [ ! -d "$CABAL_HOME" ]
	then
		__error="[$CABAL_HOME] doesnt exist"
		__var=1
		return
	fi
	export CABAL_HOME
	pathutils_add_head PATH "$CABAL_HOME/bin"
	__var=0
}

register configure_haskell

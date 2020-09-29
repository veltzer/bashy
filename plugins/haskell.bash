function configure_haskell() {
	local __user_var=$1
	CABAL_HOME="$HOME/.cabal"
	if [ -d "$CABAL_HOME" ]
	then
		export CABAL_HOME
		pathutils_add_head PATH "$CABAL_HOME/bin"
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register configure_haskell

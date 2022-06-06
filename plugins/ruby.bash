function _activate_ruby() {
	local -n __var=$1
	local -n __error=$2
	GEM_HOME="$HOME/install/gems"
	GEM_HOME_BIN="$GEM_HOME/bin"
	if ! checkDirectoryExists "$GEM_HOME" __var __error; then return; fi
	if ! checkDirectoryExists "$GEM_HOME_BIN" __var __error; then return; fi
	pathutils_add_head PATH "$GEM_HOME_BIN"
	export GEM_HOME
	__var=0
}

register _activate_ruby

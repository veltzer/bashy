function configure_ruby() {
	local -n __var=$1
	GEM_HOME="$HOME/install/gems"
	GEM_HOME_BIN="$GEM_HOME/bin"
	if [ -d "$GEM_HOME" ] && [ -d "$GEM_HOME_BIN" ]
	then
		pathutils_add_head PATH "$GEM_HOME_BIN"
		export GEM_HOME
		__var=0
		return
	fi
	__var=1
}

register configure_ruby

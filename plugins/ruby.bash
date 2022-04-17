function configure_ruby() {
	local -n __var=$1
	local -n __error=$2
	GEM_HOME="$HOME/install/gems"
	GEM_HOME_BIN="$GEM_HOME/bin"
	if [ ! -d "$GEM_HOME" ] || [ ! -d "$GEM_HOME_BIN" ]
	then
		__error="[$GEM_HOME] or [$GEM_HOME_BIN] doesnt exist"
		__var=1
		return
	fi
	pathutils_add_head PATH "$GEM_HOME_BIN"
	export GEM_HOME
	__var=0
}

register configure_ruby

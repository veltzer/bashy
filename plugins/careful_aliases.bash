function configure_careful_aliases() {
	local -n __var=$1
	# be careful aliases
	alias mv='mv -i'
	alias cp='cp -i'
	alias rm='rm -i'
	alias ln='ln -i'
	alias cd='cd -P'
	__var=0
}

register_interactive configure_careful_aliases

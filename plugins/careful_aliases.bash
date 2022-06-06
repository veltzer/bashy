function _activate_careful_aliases() {
	local -n __var=$1
	local -n __error=$2
	# be careful aliases
	alias mv='mv -i'
	alias cp='cp -i'
	alias rm='rm -i'
	alias ln='ln -i'
	alias cd='cd -P'
	__var=0
}

register_interactive _activate_careful_aliases

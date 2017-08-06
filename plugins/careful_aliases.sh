function configure_careful_aliases() {
	# be careful aliases
	alias mv='mv -i'
	alias cp='cp -i'
	alias rm='rm -i'
	alias ln="ln -i"
	result=0
}

register_interactive configure_careful_aliases

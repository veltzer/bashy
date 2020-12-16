function configure_development_aliases() {
	local -n __var=$1
	# development stuff
	alias date_mysql="date +'%F %T'"
	alias date_javascript="date -u"
	__var=0
}

register_interactive configure_development_aliases

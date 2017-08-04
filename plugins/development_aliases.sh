function configure_development_aliases() {
	# development stuff
	alias date_mysql="date +'%F %T'"
	alias date_javascript="date -u"
	return 0
}

register_interactive configure_development_aliases

function configure_development_aliases() {
	local __user_var=$1
	# development stuff
	alias date_mysql="date +'%F %T'"
	alias date_javascript="date -u"
	var_set_by_name "$__user_var" 0
}

register_interactive configure_development_aliases

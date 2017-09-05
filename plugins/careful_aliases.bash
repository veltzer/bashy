function configure_careful_aliases() {
	local __user_var=$1
	# be careful aliases
	alias mv='mv -i'
	alias cp='cp -i'
	alias rm='rm -i'
	alias ln="ln -i"
	var_set_by_name "$__user_var" 0
}

register_interactive configure_careful_aliases

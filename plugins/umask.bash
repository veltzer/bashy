function configure_umask() {
	local __user_var=$1
	# the default umask is set in /etc/profile; for setting the umask
	# for ssh logins, install and configure the libpam-umask package.
	# the default umask of ubuntu is 0002
	# this uses a stricter setting
	umask 022
	var_set_by_name "$__user_var" 0
}

register configure_umask

function _activate_umask() {
	local -n __var=$1
	local -n __error=$2
	# the default umask is set in /etc/profile; for setting the umask
	# for ssh logins, install and config the libpam-umask package.
	# the default umask of ubuntu is 0002
	# this uses a stricter setting
	umask 022
	__var=0
}

register _activate_umask

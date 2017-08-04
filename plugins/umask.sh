function configure_umask() {
	# the default umask is set in /etc/profile; for setting the umask
	# for ssh logins, install and configure the libpam-umask package.
	# the default umask of ubuntu is 0002
	# this uses a stricter setting
	umask 022
	return 0
}

register configure_umask

function configure_nomailcheck() {
	# stop bash from checking mail
	# currently it is not needed anymore since by default
	# bash doesn't do mail checking anymore
	# References:
	# - https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#index-MAILCHECK
	if [ -n "${MAILCHECK}" ]; then
		unset MAILCHECK
		return 0
	else
		return 1
	fi
}

register_interactive configure_no_mail_check

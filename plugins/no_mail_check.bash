function configure_nomailcheck() {
	local -n __var=$1
	# stop bash from checking mail
	# currently it is not needed anymore since by default
	# bash doesn't do mail checking anymore
	# References:
	# - https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#index-MAILCHECK
	if [ -n "${MAILCHECK}" ]
	then
		unset MAILCHECK
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_no_mail_check

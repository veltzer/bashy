function configure_nomailcheck() {
	local __user_var=$1
	# stop bash from checking mail
	# currently it is not needed anymore since by default
	# bash doesn't do mail checking anymore
	# References:
	# - https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#index-MAILCHECK
	if [ -n "${MAILCHECK}" ]
	then
		unset MAILCHECK
		var_set_by_name "$__user_var" 0
	else
		var_set_by_name "$__user_var" 1
	fi
}

register_interactive configure_no_mail_check

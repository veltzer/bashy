function _activate_history_for_multiple_terminals() {
	local -n __var=$1
	local -n __error=$2
	# This piece of script takes care of having consistent history
	# across multiple terminals which is good when working with
	# multiple x terminals or systems like screen or tmux
	# References:
	# - https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals
	if declare -p PROMPT_COMMAND 2> /dev/null > /dev/null
	then
		PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
	else
		PROMPT_COMMAND="history -a; history -n"
	fi
	# read the history before every command by binding to RETURN
	# https://superuser.com/questions/117227/a-command-before-every-bash-command
	# This does not work
	# bind 'RETURN: "\e[1~history -n \e[4~\n"'
	__var=0
}

register_interactive _activate_history_for_multiple_terminals

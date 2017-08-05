function configure_bash_it() {
	export BASH_IT="$HOME/.bash_it"
	if ! [ -d "$BASH_IT" ]
	then
		return 1
	fi
	# Path to the bash it configuration

	# Lock and Load a custom theme file
	# location /.bash_it/themes/
	export BASH_IT_THEME='powerline-multiline'

	# (Advanced): Change this to the name of your remote repo if you
	# cloned bash-it with a remote other than origin such as `bash-it`.
	# export BASH_IT_REMOTE='bash-it'

	# Your place for hosting Git repos. I use this for private repos.
	export GIT_HOSTING='git@git.domain.com'

	# Don't check mail when opening terminal.
	unset MAILCHECK

	# Change this to your console based IRC client of choice.
	export IRC_CLIENT='irssi'

	# Set this to the command you use for todo.txt-cli
	export TODO="t"

	# Set this to false to turn off version control status checking within the prompt for all themes
	export SCM_CHECK=true

	# Set Xterm/screen/Tmux title with only a short hostname.
	# Uncomment this (or set SHORT_HOSTNAME to something else),
	# Will otherwise fall back on $HOSTNAME.
	#export SHORT_HOSTNAME=$(hostname -s)

	# Set Xterm/screen/Tmux title with only a short username.
	# Uncomment this (or set SHORT_USER to something else),
	# Will otherwise fall back on $USER.
	#export SHORT_USER=${USER:0:8}

	# Set Xterm/screen/Tmux title with shortened command and directory.
	# Uncomment this to set.
	#export SHORT_TERM_LINE=true

	# Set vcprompt executable path for scm advance info in prompt (demula theme)
	# https://github.com/djl/vcprompt
	#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

	# (Advanced): Uncomment this to make Bash-it reload itself automatically
	# after enabling or disabling aliases, plugins, and completions.
	# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

	# Load Bash It
	bashy_before_uncertain
	source "$BASH_IT/bash_it.sh"
	bashy_after_uncertain
	return 0
}

register_interactive configure_bash_it

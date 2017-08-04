function configure_system_default_bashrc() {
	# This script sources the systems default .bashrc.
	if [ -f /etc/bash.bashrc ]; then
		before_uncertain
		source /etc/bash.bashrc
		after_uncertain
		return 0
	else
		return 1
	fi
}

register configure_system_default_bashrc

function configure_powerline() {
	# powerline
	if [ -x /usr/bin/clear_console ]
	then
		found=false
		# we prefer powerline for python3
		if [[ -f /usr/local/bin/powerline-daemon && -f /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh ]]
		then
			export POWERLINE_HOME=/usr/local/lib/python3.5/dist-packages/powerline
			POWERLINE_DAEMON=/usr/local/bin/powerline-daemon
			POWERLINE_SH=/usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh
			found=true
		elif [[ -f /usr/bin/powerline-daemon && -f /usr/share/powerline/bindings/bash/powerline.sh ]]
		then
			export POWERLINE_HOME=/usr/share/powerline
			POWERLINE_DAEMON=/usr/bin/powerline-daemon
			POWERLINE_SH=/usr/share/powerline/bindings/bash/powerline.sh
			found=true
		elif [[ -f /usr/local/bin/powerline-daemon && -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]]
		then
			export POWERLINE_HOME=/usr/local/lib/python2.7/dist-packages/powerline
			POWERLINE_DAEMON=/usr/local/bin/powerline-daemon
			POWERLINE_SH=/usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
			found=true
		fi
		if $found
		then
			POWERLINE_BASH_CONTINUATION=1
			POWERLINE_BASH_SELECT=1
			# the daemon and script may have has warnings or errors
			# and that is why we surround their code with 'bashy_before_uncertain', 'bashy_after_uncertain'
			bashy_before_uncertain
			$POWERLINE_DAEMON -q
			source $POWERLINE_SH
			bashy_after_uncertain
			result=0
		else
			result=1
		fi
	fi
}

register_interactive configure_powerline

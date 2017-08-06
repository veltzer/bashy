function configure_vi_default_editor() {
	# set up vim as the default editor
	if [[ -x /usr/bin/vim ]]
	then
		export EDITOR='vim'
		export VISUAL='vim'
		result=0
	else
		result=1
	fi
}

register_interactive configure_vi_default_editor

function configure_vi_default_editor() {
	local -n __var=$1
	if [[ -x /usr/bin/vim ]]
	then
		export EDITOR='vim'
		export VISUAL='vim'
		__var=0
		return
	fi
	__var=1
}

register_interactive configure_vi_default_editor

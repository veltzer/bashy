function configure_vi_default_editor() {
	local -n __var=$1
	local -n __error=$2
	if [[ ! -x "/usr/bin/vim" ]]
	then
		__error="[/usr/bin/vin] doesnt exist"
		__var=1
		return
	fi
	export EDITOR='vim'
	export VISUAL='vim'
	__var=0
}

register_interactive configure_vi_default_editor

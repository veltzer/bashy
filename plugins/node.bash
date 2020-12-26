function configure_node() {
	local -n __var=$1
	__var=0
	return
}

register_interactive configure_node

function node_install() {
	sudo apt-get install npm
	npm completion > "${HOME}/.bash_completion.d/npm"
}

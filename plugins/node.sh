function _activate_node() {
	local -n __var=$1
	local -n __error=$2
	NODE_HOME="${HOME}/install/node"
	if ! checkDirectoryExists "${NODE_HOME}" __var __error; then return; fi
	export NODE_HOME
	export NODE_BIN="${NODE_HOME}/bin"
	_bashy_pathutils_add_head PATH "${NODE_BIN}"
	__var=0
}

function _install_node() {
	if ! dpkg -l npm > /dev/null
	then
		sudo apt-get install npm
		echo "installed the \"npm\" package for you"
	else
		echo "you already have the \"npm\" package"
	fi
	if [ ! -f "${HOME}/.bash_completion.d/npm" ]
	then
		npm completion > "${HOME}/.bash_completion.d/npm"
		echo "setup npm completion for you"
	else
		echo "you already have npm completions"
	fi
	if [ -d "${HOME}/install/node/node_modules/.bin" ]
	then
		echo "you already have a node_modules folder"
	else
		mkdir -p "${HOME}/install/node/node_modules/.bin"
		echo "made a \"node_modules\" folder for you"
	fi
}

function npm_logout() {
	sed -i "/\(registry=\|_authToken=\)/d" "${HOME}/.npmrc"
}

register_interactive _activate_node
register_install _install_node

# this is a plugin to install and uninstall vscode from ubuntu 

function _install_code() {
	sudo tee "/etc/apt/sources.list.d/code.sources" > /dev/null << EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
	sudo wget -O "/etc/apt/keyrings/microsoft.asc" "https://packages.microsoft.com/keys/microsoft.asc" --quiet
	sudo apt update
	sudo apt install code
}

function _uninstall_code() {
	sudo rm "/etc/apt/sources.list.d/code.sources"
	sudo rm "/etc/apt/keyrings/microsoft.asc"
	sudo dpkg --purge code
	sudo apt update
}

register_install _install_code

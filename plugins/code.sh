# this is a plugin to install and uninstall vscode from ubuntu 

MSRING="/etc/apt/keyrings/microsoft.gpg"
MSKEYID="EB3E94ADBE1229CF"
MSAPT="/etc/apt/sources.list.d/code.sources"

function _install_code() {
	gpg --keyserver "keyserver.ubuntu.com" --recv-keys "${MSKEYID}"
	gpg --export --armor "${MSKEYID}" | sudo gpg --dearmor -o "${MSRING}"
	sudo tee "${MSAPT}" > /dev/null << EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: ${MSRING}
EOF
	sudo apt update
	sudo apt install code
}

function _uninstall_code() {
	sudo rm "${MSAPT}"
	sudo rm "${MSRING}"
	sudo dpkg --purge code
	sudo apt update
}

register_install _install_code

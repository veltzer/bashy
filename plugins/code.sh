# this is a plugin to install and uninstall vscode from ubuntu 

MSRING="/etc/apt/keyrings/microsoft.gpg"
MSKEYID="EB3E94ADBE1229CF"
MSAPT="/etc/apt/sources.list.d/code.sources"
PACKAGE_NAME="code"

function _install_code() {
	sudo gpg --keyserver "keyserver.ubuntu.com" --recv-keys "${MSKEYID}"
	sudo gpg --export --armor "${MSKEYID}" | sudo gpg --dearmor -o "${MSRING}"
	sudo tee "${MSAPT}" > /dev/null << EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: ${MSRING}
EOF
	sudo apt update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y code
	# sudo apt install code
}

function _uninstall_code() {
	if sudo gpg --list-keys "${MSKEYID}" &> /dev/null; then
		echo "Key [${MSKEYID}] found in personal keyring. Deleting..."
		sudo gpg --delete-keys --batch --yes "${MSKEYID}"
	else
		echo "Key [${MSKEYID}] not found in personal keyring. Nothing to do."
	fi
	if [ -f "${MSAPT}" ]
	then
		sudo rm "${MSAPT}"
	else
		echo "file [${MSAPT}] is not there, not removing"
	fi
	if [ -f "${MSRING}" ]
	then
		sudo rm "${MSRING}"
	else
		echo "file [${MSRING}] is not there, not removing"
	fi
	if dpkg-query -W -f='${Status}' "${PACKAGE_NAME}" 2>/dev/null | grep -q "install ok installed"
	then
		echo "Package [${PACKAGE_NAME}] is installed. Removing..."
		# Run the non-interactive removal
		# sudo DEBIAN_FRONTEND=noninteractive apt-get remove -y "${PACKAGE_NAME}"
		sudo dpkg --purge code
	else
		echo "Package [${PACKAGE_NAME}] is not installed. Nothing to do."
	fi
	sudo apt update
}

function _activate_code() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

register_install _install_code
register_interactive _activate_code

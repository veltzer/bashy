function _install_awscli() {
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

function _uninstall_awscli() {
	:
}

register_install _install_awscli

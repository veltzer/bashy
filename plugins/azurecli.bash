# azure completion is in /etc/bash_completion.d/azure-cli
# and comes with the azure tools deb package
# 
# Documentation about how to install the azure cli tools:
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt

function _install_azurecli() {
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

function _uninstall_azurecli() {
	:
}

function _activate_azurecli() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "az" __var __error; then return; fi
	__var=0
}

register_install _install_azurecli
register_interactive _activate_azurecli

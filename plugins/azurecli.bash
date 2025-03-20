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
	# shellcheck source=/dev/null
	if ! source "$(az completion script)"
	then
		__var=$?
		__error="could not source azure completion"
		return
	fi
	__var=0
}

register_install _install_azurecli
register_interactive _activate_azurecli

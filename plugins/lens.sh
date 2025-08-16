function _activate_lens() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "lens" __var __error; then return; fi
	__var=0
}

function _install_lens() {
	# instructions for installing lens are at
	# https://docs.k8slens.dev/getting-started/install-lens/#install-lens-desktop-from-the-appimage
	folder="${HOME}/install/binaries"
	executable="${folder}/lens"
	curl --fail --location --silent --output "${executable}" "https://api.k8slens.dev/binaries/latest.x86_64.AppImage"
	chmod +x "${executable}"
}

function _uninstall_lens() {
	folder="${HOME}/install/binaries"
	executable="${folder}/lens"
	rm -f "${executable}"
}

register _activate_lens

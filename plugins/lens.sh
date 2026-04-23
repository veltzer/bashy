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
	marker="${folder}/.lens_etag"
	url="https://api.k8slens.dev/binaries/latest.x86_64.AppImage"
	# Lens has no clean version endpoint; compare ETag/last-modified from a HEAD request.
	remote_tag=$(curl --fail --silent --head --location "${url}" | awk 'BEGIN{IGNORECASE=1} /^(etag|last-modified):/{sub(/\r$/,""); print; exit}')
	if [ -x "${executable}" ] && [ -f "${marker}" ] && [ -n "${remote_tag}" ]; then
		if [ "$(cat "${marker}")" = "${remote_tag}" ]; then
			echo "lens is already up to date"
			return
		fi
	fi
	echo "Downloading lens..."
	curl --fail --location --silent --output "${executable}" "${url}"
	chmod +x "${executable}"
	if [ -n "${remote_tag}" ]; then
		echo "${remote_tag}" > "${marker}"
	fi
}

function _uninstall_lens() {
	folder="${HOME}/install/binaries"
	executable="${folder}/lens"
	rm -f "${executable}"
}

register _activate_lens

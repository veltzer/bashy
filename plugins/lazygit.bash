# this is a plugin for lazygit
# this doesn't really do anything besides provide a function to install lazygit, I really
# need to think about plugins like that.

function _install_lazygit() {
	tar="/tmp/lazygit.tar.gz"
	rm -f "${tar}"
	download_file=$(curl --silent --location https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq --raw-output '.assets[].browser_download_url | select(endswith("_Linux_x86_64.tar.gz"))')
	echo "download_file is ${download_file}"
	curl --location --silent "${download_file}" --output "${tar}"
	folder="${HOME}/install/binaries"
	tar xf "${tar}" -C "${folder}" lazygit
	rm -f "${tar}"
	# there is not need to set the "x" bit on the file since tar extracts it with the right bits
	# executable="${folder}/lazygit"
	# chmod +x "${executable}" 
}

function _activate_lazygit() {
	:
}

register _activate_lazygit
register_install _install_lazygit

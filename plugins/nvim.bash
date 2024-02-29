function _activate_nvim_ubuntu() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "nvim" __var __error; then return; fi
	alias vi="nvim"
	__var=0
}
function _activate_nvim() {
	local -n __var=$1
	local -n __error=$2
	NVIM_PATH="${HOME}/install/nvim-linux64"
	local NVIM_PATHBIN="${NVIM_PATH}/bin"
	if ! checkDirectoryExists "${NVIM_PATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${NVIM_PATHBIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${NVIM_PATHBIN}"
	export NVIM_PATH
	alias vi="nvim"
	__var=0
}

function _install_nvim() {
	# https://github.com/neovim/neovim/blob/master/INSTALL.md
	# version="v0.8.3"
	version="latest"
	folder="${HOME}/install/binaries"
	executable="${folder}/nvim"
  rm -f "${executable}"
	# curl --location --silent --output "${executable}" "https://github.com/neovim/neovim/releases/download/${version}/nvim.appimage"
	curl --location --silent --output "${executable}" "https://github.com/neovim/neovim/releases/${version}/download/nvim.appimage"
	chmod +x "${executable}"
}

function _install_nvim_2() {
	version="latest"
	folder="${HOME}/install/nvim-linux64"
	rm -rf "${folder}"
	curl --location --silent "https://github.com/neovim/neovim/releases/${version}/download/nvim-linux64.tar.gz" | tar xz -C "${HOME}/install"
}

register_interactive _activate_nvim

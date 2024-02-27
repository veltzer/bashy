function _activate_nvim() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "nvim" __var __error; then return; fi
	alias vi="nvim"
	__var=0
}

function _install_nvim() {
	# https://github.com/neovim/neovim/blob/master/INSTALL.md
	version="v0.8.3"
	# verison="latest"
	folder="${HOME}/install/binaries"
	executable="${folder}/nvim"
	curl --location --silent --output "${executable}" "https://github.com/neovim/neovim/releases/download/${version}/nvim.appimage"
	chmod +x "${executable}"
}

function _config_nvim() {
  rm -rf "${HOME}/.config/nvim"
  # git clone "https://github.com/LunarVim/Neovim-from-scratch.git" "${HOME}/.config/nvim" > /dev/null 2> /dev/null
  git clone "https://github.com/veltzer/config-nvim.git" "${HOME}/.config/nvim" > /dev/null 2> /dev/null
}

register_interactive _activate_nvim

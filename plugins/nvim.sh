function _activate_nvim() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "nvim" __var __error; then return; fi
	alias vi="nvim"
	alias vim="nvim"
	__var=0
}
function _activate_nvim_with_folder() {
	local -n __var=$1
	local -n __error=$2
	NVIM_PATH="${HOME}/install/nvim-linux-x86_64"
	local NVIM_PATHBIN="${NVIM_PATH}/bin"
	if ! checkDirectoryExists "${NVIM_PATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${NVIM_PATHBIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${NVIM_PATHBIN}"
	export NVIM_PATH
	# alias vi="nvim"
	# alias vim="nvim"
	__var=0
}

function _install_nvim() {
	# https://github.com/neovim/neovim/blob/master/INSTALL.md
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/neovim/neovim/releases/latest" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/binaries"
	executable="${folder}/nvim"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^NVIM v/{print substr($2,2); exit}')
	fi
	if bashy_install_check "nvim" "${installed_version}" "${latest_version}"
	then
		return
	fi
	rm -f "${executable}"
	curl --fail --location --silent --output "${executable}" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
	chmod +x "${executable}"
}

function _install_nvim_latest_tar() {
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/neovim/neovim/releases/latest" | jq --raw-output '.tag_name' | sed 's/^v//')
	folder="${HOME}/install/nvim-linux-x86_64"
	executable="${folder}/bin/nvim"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^NVIM v/{print substr($2,2); exit}')
	fi
	if bashy_install_check "nvim" "${installed_version}" "${latest_version}"
	then
		return
	fi
	download_file="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	rm -rf "${folder}"
	bashy_install_extract "${tar}" "${HOME}/install"
}

function _install_nvim_nightly_tar() {
	version="nightly"
	folder="${HOME}/install/nvim-linux-x86_64"
	download_file="https://github.com/neovim/neovim-releases/releases/download/${version}/nvim-linux-x86_64.tar.gz"
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	rm -rf "${folder}"
	bashy_install_extract "${tar}" "${HOME}/install"
}

function _install_nvim_ubuntu() {
	sudo apt install neovim
}

function _install_nvim_lazy() {
	# remove previous config
	rm -rf "${HOME}/.config/nvim"
	# Clone starter
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	nvim --headless "+Lazy! sync" +qa
}

function _clean_nvim() {
	rm -rf "${HOME}/.cache/nvim" "${HOME}/.local/share/nvim" "${HOME}/.local/state/nvim"
}

function _config_clean_nvim() {
	rm -rf "${HOME}/.config/nvim"
}

function _uninstall_nvim() {
	bashy_uninstall_binary "nvim"
}

register_interactive _activate_nvim

# https://starship.rs/

function _activate_starship() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "starship" __var __error; then return; fi
	eval "$(starship init bash)"
	# shellcheck source=/dev/null
	if ! source <(starship completions bash)
	then
		__var=$?
		__error="could not source startship completion"
		return
	fi
	__var=0
}

function _install_starship() {
	latest_version=$(curl --fail --silent --location "https://api.github.com/repos/starship/starship/releases/latest" | jq --raw-output '.tag_name' | sed 's/^v//')
	executable="${HOME}/install/binaries/starship"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^starship /{print $2; exit}')
	fi
	if bashy_install_check "starship" "${installed_version}" "${latest_version}"
	then
		return
	fi
	BIN_DIR="${HOME}/install/binaries" sh <(curl --fail --silent https://starship.rs/install.sh) -y
}

function _uninstall_starship() {
	bashy_uninstall_binary "starship"
}

register_interactive _activate_starship
register_install _install_starship

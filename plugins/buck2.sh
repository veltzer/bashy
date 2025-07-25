# this is a plugin for buck2

function _install_buck2() {
	before_strict
	url="https://github.com/facebook/buck2/releases/download/latest/buck2-x86_64-unknown-linux-gnu.zst"
	local_file="/tmp/file.zst"
	final="${HOME}/install/binaries/buck2"
	curl --silent --location "${url}" --output "${local_file}"
	zstd -d "${local_file}" -o "${final}"
	chmod +x "${final}"
	after_strict
}

function _uninstall_buck2() {
	before_strict
	final="${HOME}/install/binaries/buck2"
	rm -f "${final}"
	after_strict
}

function _activate_buck2() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "buck2" __var __error; then return; fi
	eval "$(buck2 completion bash)"
	__var=0
}

register_interactive _activate_buck2

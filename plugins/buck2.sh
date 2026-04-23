# this is a plugin for buck2

function _install_buck2() {
	before_strict
	# buck2 ships a rolling "latest" tag; buck2 --version reports a git hash, not semver.
	# Compare against the GitHub release's published_at timestamp to decide if we need to upgrade.
	final="${HOME}/install/binaries/buck2"
	marker="${HOME}/install/binaries/.buck2_published_at"
	latest_stamp=$(curl --fail --silent --location "https://api.github.com/repos/facebook/buck2/releases/tags/latest" | jq --raw-output '.published_at // empty')
	if [ -x "${final}" ] && [ -f "${marker}" ] && [ -n "${latest_stamp}" ]; then
		if [ "$(cat "${marker}")" = "${latest_stamp}" ]; then
			echo "buck2 (published ${latest_stamp}) is already installed (latest)"
			after_strict
			return
		fi
	fi
	url="https://github.com/facebook/buck2/releases/download/latest/buck2-x86_64-unknown-linux-gnu.zst"
	local_file="/tmp/file.zst"
	curl --fail --silent --location "${url}" --output "${local_file}"
	zstd -d "${local_file}" -o "${final}"
	rm -f "${local_file}"
	chmod +x "${final}"
	if [ -n "${latest_stamp}" ]; then
		echo "${latest_stamp}" > "${marker}"
	fi
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

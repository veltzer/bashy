# This is integration of bazel
function _activate_bazel() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "bazel" __var __error; then return; fi
	export BAZEL_OPTS="--host_jvm_args=-XX:+IgnoreUnrecognizedVMOptions"
	export BAZEL_JVM_FLAGS="-XX:+IgnoreUnrecognizedVMOptions"
	__var=0
}

function _install_bazel() {
	before_strict
	release_json=$(curl --fail --silent --location "https://api.github.com/repos/bazelbuild/bazel/releases/latest")
	latest_version=$(echo "${release_json}" | jq --raw-output '.tag_name')
	executable="${HOME}/install/binaries/bazel"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^bazel /{print $2; exit}')
	fi
	if bashy_install_check "bazel" "${installed_version}" "${latest_version}"
	then
		after_strict
		return
	fi
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("-linux-x86_64")) | select(contains("nojdk") | not)')
	bashy_install_download "${download_file}"
	local binary
	bashy_download "${download_file}" binary || { after_strict; return; }
	bashy_verify_sha256 "${binary}" "${download_file}.sha256" || { after_strict; return; }
	rm -f "${executable}"
	cp "${binary}" "${executable}"
	chmod +x "${executable}"
	after_strict
}

function _uninstall_bazel() {
	bashy_uninstall_binary "bazel"
}

register_interactive _activate_bazel

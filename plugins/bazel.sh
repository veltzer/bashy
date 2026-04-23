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
	if [ -x "${executable}" ]; then
		installed_version=$("${executable}" --version 2>/dev/null | awk '/^bazel /{print $2; exit}')
		if [ "${installed_version}" = "${latest_version}" ]; then
			echo "bazel ${latest_version} is already installed (latest)"
			after_strict
			return
		fi
		echo "bazel ${installed_version} is installed, upgrading to ${latest_version}"
	else
		echo "Installing bazel ${latest_version}"
	fi
	download_file=$(echo "${release_json}" | jq --raw-output '.assets[].browser_download_url | select(endswith("-linux-x86_64")) | select(contains("nojdk") | not)')
	echo "download_file is ${download_file}"
	curl --fail --location --silent "${download_file}" --output "${executable}"
	chmod +x "${executable}"
	after_strict
}

register_interactive _activate_bazel

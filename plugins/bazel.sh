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
	download_file=$(curl --silent --location https://api.github.com/repos/bazelbuild/bazel/releases/latest | jq --raw-output '.assets[].browser_download_url | select(endswith("-linux-x86_64")) | select(contains("nojdk") | not)')
	echo "download_file is ${download_file}"
	executable="${HOME}/install/binaries/bazel"
	curl --location --silent "${download_file}" --output "${executable}"
	chmod +x "${executable}" 
	# now for completion
	# target="${HOME}/.bash_completion.d/bazel"
	# curl --location --silent --output "${target}" "https://raw.githubusercontent.com/bazelbuild/bazel/master/scripts/bazel-complete.bash"
	after_strict
}

register_interactive _activate_bazel

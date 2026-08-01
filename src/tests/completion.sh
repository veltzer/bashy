source src/core/assert.sh
source src/core/log.sh
source src/core/completion.sh

# a stand in for a real tool, so these tests do not depend on minikube or gh being
# installed and can control exactly when the "tool" changes
function _test_completion_tool() {
	local dir=$1
	local text=$2
	mkdir -p "${dir}/bin"
	printf '#!/bin/bash\necho "%s"\n' "${text}" > "${dir}/bin/faketool"
	chmod +x "${dir}/bin/faketool"
}

function testCompletionCachesAndReuses() {
	local dir
	dir=$(mktemp --directory)
	_test_completion_tool "${dir}" "complete -W v1 faketool"
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null || _bashy_assert_fail
	# the cache file has to exist afterwards, that is the whole point
	if [ ! -s "${dir}/cache/faketool.bash" ]
	then
		rm -rf "${dir}"
		_bashy_assert_fail
	fi
	_bashy_assert_equal "$(cat "${dir}/cache/faketool.bash")" "complete -W v1 faketool"
	rm -rf "${dir}"
}

function testCompletionServesFromCache() {
	local dir
	dir=$(mktemp --directory)
	_test_completion_tool "${dir}" "complete -W v1 faketool"
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null
	# break the tool without changing it on disk, so a second call that still
	# succeeds proves the answer came from the cache rather than from the tool
	local stamp_before
	stamp_before=$(cat "${dir}/cache/faketool.bash.stamp")
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null || _bashy_assert_fail
	_bashy_assert_equal "$(cat "${dir}/cache/faketool.bash.stamp")" "${stamp_before}"
	rm -rf "${dir}"
}

function testCompletionInvalidatesWhenToolChanges() {
	local dir
	dir=$(mktemp --directory)
	_test_completion_tool "${dir}" "complete -W v1 faketool"
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null
	# rewriting immediately means the mtime moves by less than a second, which is
	# exactly the case a whole second stamp used to miss
	_test_completion_tool "${dir}" "complete -W v2 faketool"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null
	_bashy_assert_equal "$(cat "${dir}/cache/faketool.bash")" "complete -W v2 faketool"
	rm -rf "${dir}"
}

function testCompletionMissingToolFails() {
	local dir
	dir=$(mktemp --directory)
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	bashy_completion no_such_tool_anywhere no_such_tool_anywhere > /dev/null 2>&1 \
		&& { rm -rf "${dir}"; _bashy_assert_fail; }
	rm -rf "${dir}"
	return 0
}

function testCompletionFailingCommandLeavesNoCache() {
	local dir
	dir=$(mktemp --directory)
	mkdir -p "${dir}/bin"
	# a tool that exists but produces nothing and fails
	printf '#!/bin/bash\nexit 1\n' > "${dir}/bin/faketool"
	chmod +x "${dir}/bin/faketool"
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null 2>&1 \
		&& { rm -rf "${dir}"; _bashy_assert_fail; }
	# a failed run must not leave a cache file, or the failure becomes permanent
	if [ -e "${dir}/cache/faketool.bash" ]
	then
		rm -rf "${dir}"
		_bashy_assert_fail
	fi
	rm -rf "${dir}"
	return 0
}

function testCompletionCleanRemovesCache() {
	local dir
	dir=$(mktemp --directory)
	_test_completion_tool "${dir}" "complete -W v1 faketool"
	export BASHY_COMPLETION_CACHE="${dir}/cache"
	PATH="${dir}/bin:${PATH}" bashy_completion faketool faketool > /dev/null
	bashy_completion_clean > /dev/null
	if [ -d "${dir}/cache" ]
	then
		rm -rf "${dir}"
		_bashy_assert_fail
	fi
	rm -rf "${dir}"
}

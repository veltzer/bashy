# Cached shell completions.
#
# Most tools ship their bash completion by printing it: "minikube completion bash",
# "gh completion -s bash", "starship init bash". Running those at every shell start
# is what made bashy slow - each one is a process spawn, and minikube alone takes
# over a tenth of a second.
#
# The output only changes when the tool itself changes, so generate it once, keep it
# in a cache file, and source the file afterwards. The cache is keyed on the mtime
# and size of the tool's binary, so upgrading the tool regenerates it by itself.
#
# Only worth it for slow tools. A cached call still costs about 10 ms of its own,
# for "command -v", a "stat" and sourcing the file, so a tool that emits its
# completion in under that is faster left alone. The tools cached here take 20 to
# 80 ms natively; the seven rs* tools in plugins/complete.sh take 5 to 15 ms and
# were measurably slower when routed through here.
#
# Usage from a plugin, in place of "source <(minikube completion bash)":
#
#	bashy_completion minikube minikube completion bash
#
# The first argument is the tool whose binary keys the cache, the rest is the
# command to run. Returns non zero if the tool is missing or the command fails,
# so a plugin can report it the usual way:
#
#	if ! bashy_completion uv uv --generate-shell-completion bash
#	then
#		__var=1
#		__error="could not load uv completion"
#		return
#	fi

# location of the cache, honoring XDG_CACHE_HOME, overridable via BASHY_COMPLETION_CACHE
if [ -z "${BASHY_COMPLETION_CACHE+x}" ]
then
	export BASHY_COMPLETION_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/bashy/completions"
fi

# _bashy_completion_stamp <path>
# Echo a short string that changes whenever the file at <path> changes.
# Uses size and mtime rather than a hash, since hashing a 100MB binary at every
# shell start would cost more than the completion command it is meant to avoid.
# The mtime is taken with nanoseconds (%.Y, not %Y): whole seconds are too coarse,
# a tool replaced within the same second as the last stamp would keep serving the
# previous completion.
function _bashy_completion_stamp() {
	stat --format='%s-%.Y' "$1" 2>/dev/null
}

# bashy_completion <tool> <command...>
# Source the bash completion produced by <command...>, through a cache keyed on the
# binary of <tool>. Returns 0 on success, non zero when the tool is absent or the
# command fails.
function bashy_completion() {
	local tool=$1
	shift
	local path
	if ! path=$(command -v "${tool}" 2>/dev/null)
	then
		return 1
	fi
	local stamp
	stamp=$(_bashy_completion_stamp "${path}")
	local cache="${BASHY_COMPLETION_CACHE}/${tool}.bash"
	local stamp_file="${cache}.stamp"
	# regenerate when the tool changed, or when we have never run it
	if [ ! -s "${cache}" ] || [ "$(cat "${stamp_file}" 2>/dev/null)" != "${stamp}" ]
	then
		mkdir -p "${BASHY_COMPLETION_CACHE}"
		local tmp="${cache}.$$"
		if ! "$@" > "${tmp}" 2>/dev/null || [ ! -s "${tmp}" ]
		then
			rm -f "${tmp}"
			return 1
		fi
		mv -f "${tmp}" "${cache}"
		echo "${stamp}" > "${stamp_file}"
	fi
	# shellcheck source=/dev/null
	source "${cache}"
}

# bashy_completion_clean
# Drop the completion cache, so every tool regenerates on the next shell.
function bashy_completion_clean() {
	if [ -d "${BASHY_COMPLETION_CACHE}" ]
	then
		echo "removing completion cache [${BASHY_COMPLETION_CACHE}]"
		rm -rf "${BASHY_COMPLETION_CACHE}"
	else
		echo "no completion cache at [${BASHY_COMPLETION_CACHE}]"
	fi
}

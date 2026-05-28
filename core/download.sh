# Download cache for bashy plugins.
#
# Plugins used to download archives into /tmp and delete them right after
# extraction. This module gives them a persistent, content-addressed cache so
# that re-installing the same version skips the network entirely.
#
# Usage from a plugin:
#
#	local archive
#	bashy_download "${url}" archive || return 1
#	tar xf "${archive}" -C "${folder}" something
#
# The cached file is left in place on purpose - that is the whole point of the
# cache. Plugins should NOT 'rm' the path that bashy_download returns.

# location of the cache, honoring XDG_CACHE_HOME, overridable via BASHY_DOWNLOAD_CACHE
if [ -z "${BASHY_DOWNLOAD_CACHE+x}" ]
then
	export BASHY_DOWNLOAD_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/bashy/downloads"
fi

# bashy_download <url> [out_var]
# Ensure <url> is present in the download cache and return its local path.
# If out_var is given the path is assigned to it, otherwise it is echoed.
# Returns 0 on success, 1 on failure.
function bashy_download() {
	local url=$1
	local basename="${url##*/}"
	if [ -z "${basename}" ]
	then
		echo "bashy_download: cannot derive a filename from url [${url}]" >&2
		return 1
	fi
	local target="${BASHY_DOWNLOAD_CACHE}/${basename}"
	if [ -s "${target}" ]
	then
		bashy_log "core/download" "${BASHY_LOG_INFO}" "cache hit for [${basename}]"
	else
		bashy_log "core/download" "${BASHY_LOG_INFO}" "downloading [${url}]"
		mkdir -p "${BASHY_DOWNLOAD_CACHE}"
		# download to a temp file in the cache dir so an interrupted download
		# never leaves a truncated file that would later look like a cache hit
		local tmp="${target}.part"
		if ! curl --fail --location --silent --show-error "${url}" --output "${tmp}"
		then
			echo "bashy_download: failed to download [${url}]" >&2
			rm -f "${tmp}"
			return 1
		fi
		mv -f "${tmp}" "${target}"
	fi
	if [ -n "${2+x}" ]
	then
		local -n __out=$2
		__out="${target}"
	else
		echo "${target}"
	fi
}

# bashy_download_clean
# Remove the entire download cache.
function bashy_download_clean() {
	if [ -d "${BASHY_DOWNLOAD_CACHE}" ]
	then
		echo "removing download cache [${BASHY_DOWNLOAD_CACHE}]"
		rm -rf "${BASHY_DOWNLOAD_CACHE}"
	else
		echo "no download cache at [${BASHY_DOWNLOAD_CACHE}]"
	fi
}

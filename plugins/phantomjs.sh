function _activate_phantomjs() {
	local -n __var=$1
	local -n __error=$2
	PHANTOMJSPATH="${HOME}/install/phantomjs"
	PHANTOMJSPATHBIN="${PHANTOMJSPATH}/bin"
	if ! checkDirectoryExists "${PHANTOMJSPATH}" __var __error; then return; fi
	if ! checkDirectoryExists "${PHANTOMJSPATHBIN}" __var __error; then return; fi
	_bashy_pathutils_add_head PATH "${PHANTOMJSPATHBIN}"
	export PHANTOMJSPATH
	__var=0
}

function _install_phantomjs() {
	before_strict
	base="phantomjs-2.1.1-linux-x86_64"
	full="${base}.tar.bz2"
	installed_version=""
	if [ -d "${HOME}/install/${base}" ]
	then
		installed_version="${base}"
	fi
	if bashy_install_check "phantomjs" "${installed_version}" "${base}"
	then
		after_strict
		return
	fi
	url="https://bitbucket.org/ariya/phantomjs/downloads/${full}"
	local archive
	bashy_download "${url}" archive || { after_strict; return; }
	bashy_install_extract "${archive}" "${HOME}/install"
	rm -f "${HOME}/install/phantomjs" || true
	ln -sfn "${HOME}/install/${base}" "${HOME}/install/phantomjs"
	after_strict
}

register _activate_phantomjs

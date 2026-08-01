# Shared reporting for plugin installers.
#
# Every _install_* function used to hand roll the same three messages, which
# drifted over time ("is already installed", "is already up to date",
# "Upgrading foo from [x] to [y]", ...). This module keeps that wording in one
# place so all plugins report identically.
#
# Usage from a plugin:
#
#	if bashy_install_check "gh" "${installed_version}" "${latest_version}"
#	then
#		return
#	fi
#	# ... download and install ...
#
# and with strict mode:
#
#	if bashy_install_check "gh" "${installed_version}" "${latest_version}"
#	then
#		after_strict
#		return
#	fi

# Where plugins put the single binaries they install. Override in ~/.bashy.config.
if [ -z "${BASHY_INSTALL_DIR+x}" ]
then
	export BASHY_INSTALL_DIR="${HOME}/install/binaries"
fi

# bashy_install_dir
# Echo the install directory, creating it if it is not there yet. Installers used
# to just assume it existed and failed obscurely on a fresh machine when it did not.
function bashy_install_dir() {
	if [ ! -d "${BASHY_INSTALL_DIR}" ]
	then
		mkdir -p "${BASHY_INSTALL_DIR}"
	fi
	echo "${BASHY_INSTALL_DIR}"
}

# bashy_install_check <name> <installed_version> <latest_version>
# Report what is about to happen and say whether there is anything to do.
# An empty <installed_version> means the tool is not installed yet.
# Returns 0 if <name> is already at <latest_version> (caller should return),
# 1 if the caller should go on and install.
function bashy_install_check() {
	local name=$1
	local installed=$2
	local latest=$3
	if [ -z "${latest}" ]
	then
		echo "${name}: could not determine the latest version" >&2
		return 1
	fi
	if [ -z "${installed}" ]
	then
		echo "Installing ${name} ${latest}"
		return 1
	fi
	if [ "${installed}" = "${latest}" ]
	then
		echo "${name} ${latest} is already installed (latest)"
		return 0
	fi
	echo "${name} ${installed} is installed, upgrading to ${latest}"
	return 1
}

# bashy_install_download <url>
# Report the artifact a plugin is about to fetch, in one consistent format.
function bashy_install_download() {
	echo "download_file is [$1]"
}

# bashy_uninstall_binary <name> [executable path]
# Remove a single binary installed into BASHY_INSTALL_DIR, reporting either way.
# The path defaults to ${BASHY_INSTALL_DIR}/<name>.
function bashy_uninstall_binary() {
	local name=$1
	local executable=${2:-${BASHY_INSTALL_DIR}/$1}
	if [ -f "${executable}" ]
	then
		echo "removing ${executable}"
		rm -f "${executable}"
	else
		echo "no ${name} detected"
	fi
	return 0
}

# bashy_uninstall_directory <name> <directory> [more directories...]
# Remove the directory tree(s) a plugin installed, reporting either way.
# Handy for the plugins that unpack a whole toolchain rather than one binary.
function bashy_uninstall_directory() {
	local name=$1
	shift
	local found=1
	local directory
	for directory in "$@"
	do
		# a plugin may leave both a versioned directory and a symlink to it
		if [ -d "${directory}" ] || [ -L "${directory}" ]
		then
			echo "removing ${directory}"
			rm -rf "${directory}"
			found=0
		fi
	done
	if [ "${found}" -ne 0 ]
	then
		echo "no ${name} detected"
	fi
	return 0
}

# bashy_github_release <owner/repo> [out_var]
# Fetch the json of the latest release of a github project.
# Assigns to out_var when given, otherwise echoes. Returns 1 when the fetch fails.
function bashy_github_release() {
	local repo=$1
	local json
	if ! json=$(curl --fail --silent --location "https://api.github.com/repos/${repo}/releases/latest")
	then
		echo "bashy_github_release: could not fetch the latest release of [${repo}]" >&2
		return 1
	fi
	if [ -n "${2:-}" ]
	then
		local -n __out=$2
		__out="${json}"
	else
		echo "${json}"
	fi
}

# bashy_github_version <release json> [prefix]
# Echo the version of a release, with <prefix> stripped from the tag name.
# The prefix defaults to "v", which is what almost every project tags with.
function bashy_github_version() {
	local json=$1
	local prefix=${2-v}
	echo "${json}" | jq --raw-output '.tag_name' | sed "s/^${prefix}//"
}

# bashy_github_asset <release json> <jq test regex> [out_var]
# Echo the download url of the one asset of a release matching <jq test regex>.
# Fails when the pattern matches no asset, or more than one - an ambiguous match
# silently produced a multi line url before, which is never what a caller wants.
function bashy_github_asset() {
	local json=$1
	local pattern=$2
	local urls
	urls=$(echo "${json}" | jq --raw-output --arg re "${pattern}" \
		'.assets[].browser_download_url | select(test($re))')
	local count
	count=$(echo "${urls}" | grep --count . || true)
	if [ "${count}" -eq 0 ]
	then
		echo "bashy_github_asset: no asset matches [${pattern}]" >&2
		return 1
	fi
	if [ "${count}" -gt 1 ]
	then
		echo "bashy_github_asset: [${pattern}] matches ${count} assets, expected one:" >&2
		echo "${urls}" >&2
		return 1
	fi
	if [ -n "${3:-}" ]
	then
		local -n __out=$3
		__out="${urls}"
	else
		echo "${urls}"
	fi
}

# bashy_install_extract <archive> <destination folder> [tar/unzip arguments...]
# Unpack <archive> into <destination folder>, then stamp everything it wrote with
# the current time. Both tar and unzip restore the mtime recorded inside the
# archive, which makes a freshly installed file look years old.
function bashy_install_extract() {
	local archive=$1
	local folder=$2
	shift 2
	case "${archive}" in
		*.zip)
			unzip -q -o "${archive}" -d "${folder}" "$@" || return 1
			# unzip has no equivalent of tar --touch, so restamp afterwards
			local member
			for member in "$@"
			do
				touch "${folder}/${member}" 2>/dev/null || true
			done
			;;
		*)
			tar xf "${archive}" -m -C "${folder}" "$@" || return 1
			;;
	esac
}

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

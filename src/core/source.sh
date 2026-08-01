# A set of functions that help you to source other sources
#
# Features:
# - a single place that centralizes sourcing code.
# - a protection against double inclusion.

# protect against double inclusion
if [ -n "${SOURCE-}" ]
then
	return
fi

SOURCE=1

declare -gA sourced=()

function _bashy_source_relative() {
	local file=$1
	local path="${BASH_SOURCE%/*}/${file}"
	if ! [ "${sourced[${path}]+muahaha}" ]
	then
		sourced[${path}]=1
		# shellcheck source=/dev/null
		source "${path}"
	fi
}

function _bashy_source_absolute() {
	local file=$1
	local path
	path=$(realpath "${file}")
	if ! [ "${sourced[${path}]+muahaha}" ]
	then
		sourced[${path}]=1
		# shellcheck source=/dev/null
		source "${path}"
	fi
}

#!/bin/bash -eu

# Install bashy into ~/.bashy.
#
# What gets installed is listed in .includes, which is an allow list: its last line
# excludes everything, so anything not named there stays out of ~/.bashy.
#
# This is incremental. Files that are identical are neither printed nor copied, so
# the list below is exactly what changed. --delete removes anything in ~/.bashy that
# is no longer part of the install, which is what keeps a renamed or dropped plugin
# from lingering there.
#
# -c compares by checksum rather than size and mtime, so a file that was merely
# touched does not count as changed.

target="${HOME}/.bashy"

# rsync flags shared by the preview and the real run, so the preview cannot
# describe a different operation than the one that follows it
declare -a flags=(
	--archive
	--checksum
	--delete
	--itemize-changes
	--human-readable
	--include-from=.includes
)

# --dry-run prints the same itemized list the real run would, without touching disk.
#
# The itemize codes are "YXcstpoguax": position 3 is c for a content change, and a
# leading > or * marks a transfer or a deletion. A line where only t (mtime) differs
# means the content is identical and rsync is merely restoring the timestamp, which
# is not a change worth reporting. Keep only real ones.
changes=$(rsync "${flags[@]}" --dry-run ./ "${target}/" \
	| grep -E '^(>|<|\*|c[dfLDS])' \
	| grep -vE '^\.[fdLDS]\.\.t' \
	|| true)

if [ -z "${changes}" ]
then
	echo "  (none, ${target} is up to date)"
	exit 0
fi
printf '  %s\n' "${changes}"

# the preview above is the report, so let the real run work quietly. It still has to
# carry --itemize-changes so that it is the same operation that was previewed.
rsync "${flags[@]}" ./ "${target}/" > /dev/null

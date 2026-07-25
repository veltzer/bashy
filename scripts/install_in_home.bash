#!/bin/bash -eu

# What gets installed is listed in .includes, which is an allow list: its last line
# excludes everything, so anything not named there stays out of ~/.bashy.

rsync -rvnc --delete ./ ~/.bashy --include-from=.includes
rm -rf "${HOME}/.bashy"
rsync --archive ./ ~/.bashy --include-from=.includes

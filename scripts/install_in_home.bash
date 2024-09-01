#!/bin/bash -eu

rsync -rvnc --delete ./ ~/.bashy --exclude-from=.excludes
rm -rf "${HOME}/.bashy"
rsync --archive ./ ~/.bashy --exclude-from=.excludes

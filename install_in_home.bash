#!/bin/bash -eu

rm -rf "${HOME}/.bashy"
# rsync --archive --itemize-changes ./ ~/.bashy --exclude-from=.excludes
rsync --archive ./ ~/.bashy --exclude-from=.excludes

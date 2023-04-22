#!/bin/bash -eu

rm -rf "${HOME}/.bashy"
rsync -a ./ ~/.bashy --exclude-from=.excludes

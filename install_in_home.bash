#!/bin/bash -eu

rm -rf ~/.bashy
rsync -a ./ ~/.bashy --exclude-from=.excludes

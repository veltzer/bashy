#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/assert.bashinc
source_relative ../core/pathutils.bashinc

P="/usr/games:/usr/bin:/bin"
R="/usr/games"

pathutils_remove P $R
assertEqual "$P" "/usr/bin:/bin"

pathutils_add_head R "/bin"
assertEqual "$R" "/bin:/usr/games"

before_path=$PATH
pathutils_add_head PATH "/opt"
assertEqual "/opt:$before_path" "$PATH"

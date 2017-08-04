#!/bin/bash

# a test suite for .pathutils.sh

source ../core/pathutils.sh

P="/usr/games:/usr/bin:/bin"
R="/usr/games"

pathutils_remove "$P" "$R"

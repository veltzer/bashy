#!/bin/bash

# a test suite for .pathutils.sh

source ../core/pathutils.sh

P="/usr/games:/usr/bin:/bin"
R="/usr/games"

pathutils_remove P $R
if [ "$P" != "/usr/bin:/bin" ]
then
	echo "ERROR"
fi

pathutils_add_head R "/bin"
if [ "$R" != "/bin:/usr/games" ]
then
	echo "ERROR"
fi

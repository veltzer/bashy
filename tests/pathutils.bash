#!/bin/bash -eu

source ../core/pathutils.bashinc

P="/usr/games:/usr/bin:/bin"
R="/usr/games"

pathutils_remove P $R
if [ "$P" != "/usr/bin:/bin" ]
then
	echo "ERROR1"
fi

pathutils_add_head R "/bin"
if [ "$R" != "/bin:/usr/games" ]
then
	echo "ERROR2"
fi

before_path=$PATH
pathutils_add_head PATH "/opt"
if [ "/opt:$before_path" != "$PATH" ]
then
	echo "ERROR3"
fi

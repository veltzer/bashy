#!/bin/bash -eu

source core/python.bashinc

python_version_short a "/usr/bin/python2.7"
if [ "$a" != "2.7" ]
then
	echo "ERROR"
fi

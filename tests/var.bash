#!/bin/bash -eu

# a test suite for var.bashinc

source ../core/var.bashinc

b=5
var_set_by_name b 6
if [ "$b" != 6 ]
then
	echo "ERROR"
fi

function test_it() {
	local c=5
	var_set_by_name c 6
	if [ "$c" != 6 ]
	then
		echo "ERROR"
	fi
}

test_it

if ! var_is_defined PATH
then
	echo "ERROR"
fi
if var_is_defined PATHY
then
	echo "ERROR"
fi

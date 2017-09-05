#!/bin/bash

# a test suite for var.bashinc

source ../core/var.bashinc

b=5
var_set_by_name b 6
if [ "$b" != 6 ]
then
	echo "ERROR"
fi

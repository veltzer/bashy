#!/bin/bash -eu

source ../core/array.bashinc

array_new my_array
array_set my_array 2 4
array_length my_array len
if [ "$len" != 1 ]
then
	echo "ERROR"
fi

array_new arr2
array_set arr2 0 a
array_set arr2 1 b
array_set arr2 2 c
array_print arr2

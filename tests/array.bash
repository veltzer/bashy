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
d=5
array_pop arr2 d
if [ "$d" != "c" ]
then
	echo "ERROR"
fi
array_pop arr2 d
if [ "$d" != "b" ]
then
	echo "ERROR"
fi
array_pop arr2 d
if [ "$d" != "a" ]
then
	echo "ERROR"
fi

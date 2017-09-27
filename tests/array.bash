#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/assert.bashinc
source_relative ../core/array.bashinc

array_new my_array
array_set my_array 2 4
array_length my_array len
assertEqual "$len" 1

array_new arr2
array_set arr2 0 a
array_set arr2 1 b
array_set arr2 2 c
d=5
array_pop arr2 d
assertEqual "$d" c
array_pop arr2 d
assertEqual "$d" b
array_pop arr2 d
assertEqual "$d" a

array_new arr3
array_push arr3 a
array_push arr3 b
array_push arr3 c
d=5
array_pop arr3 d
assertEqual "$d" c
array_pop arr3 d
assertEqual "$d" b
array_pop arr3 d
assertEqual "$d" a

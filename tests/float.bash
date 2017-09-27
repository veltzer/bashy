#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/assert.bashinc
source_relative ../core/float.bashinc

if floatGt 3.14 3.22
then
	assertFail
fi

floatAdd d 0.2 1.4
assertEqual $d 1.6

floatDiv d 1.4 0.2
assertLt $d 7.1
assertGt $d 6.9

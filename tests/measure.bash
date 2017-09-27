#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/var.bashinc
source_relative ../core/measure.bashinc
source_relative ../core/float.bashinc

function test_it() {
	sleep 2
}

measure diff test_it 2
assertLt $diff 2.1
assertGt $diff 1.9

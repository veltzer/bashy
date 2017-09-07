#!/bin/bash -eu

source ../core/var.bashinc
source ../core/measure.bashinc

function test_it() {
	sleep 2
}

measure diff test_it 2
echo "diff is [$diff]"

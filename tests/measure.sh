source core/var.bashinc
source core/measure.bashinc
source core/float.bashinc

function sleep_a_little() {
	sleep 2
}

function testMeasure() {
	measure diff sleep_a_little 2
	assertLt $diff 2.1
	assertGt $diff 1.9
}

source shunit2

source core/var.bash
source core/measure.bash
source core/float.bash

function sleep_a_little() {
	sleep 2
}

function testMeasure() {
	diff=
	measure diff sleep_a_little 2
	assertLt "$diff" 2.1
	assertGt "$diff" 1.9
}

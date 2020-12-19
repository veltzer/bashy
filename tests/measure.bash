source core/var.bash
source core/measure.bash
source core/float.bash

function sleep_a_little() {
	sleep 2
}

function testMeasure() {
	local diff=
	local result=
	measure diff sleep_a_little result
	# echo "diff is $diff"
	# echo "result is $result"
	assertLt "$diff" 2.1
	assertGt "$diff" 1.9
}

source core/var.bash
source core/measure.bash
source core/float.bash

function sleep_a_little() {
	sleep 2
}

function test_measure() {
	local diff=
	local result=
	# shellcheck disable=2034
	local error=
	measure diff sleep_a_little result error
	# echo "diff is ${diff}"
	# echo "result is ${result}"
	_bashy_assert_lt "${diff}" 2.1
	_bashy_assert_gt "${diff}" 1.9
}
